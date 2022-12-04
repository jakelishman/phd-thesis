import numpy as np
import scipy.optimize

class EvenSystem:
    def __init__(self, n):
        self.n = n
        arange = np.arange(n, dtype=np.float64)
        self.sign = np.empty((n, n), dtype=np.float64)
        np.sign(np.subtract.outer(arange, arange, out=self.sign), out=self.sign)
        self.diag = np.diag_indices(n)
        self.offdiag = np.logical_not(np.eye(n, dtype=bool))
        self._last = None
        self._f = None
        self._jac = np.empty((n, n), dtype=np.float64)

    def _cache(self, x):
        x = np.array(x, dtype=np.float64, copy=False)
        if x is self._last:
            return
        self._last = x
        radd = 1 / np.add.outer(x, x)
        radd2 = radd**2
        radd3 = radd2 * radd
        sub = np.subtract.outer(x, x)
        rsub = np.empty_like(radd)
        rsub[self.diag] = 0
        rsub[self.offdiag] = 1 / sub[self.offdiag]
        rsub2 = self.sign * rsub**2
        rsub3 = rsub2 * rsub
        self._f = x - np.sum(radd2, axis=0) + np.sum(rsub2, axis=0)
        self._jac[self.diag] = 1 + 2*(radd3[self.diag] + np.sum(radd3[self.offdiag], axis=0) + np.sum(rsub3, axis=0))
        self._jac[self.offdiag] = -2*(radd3[self.offdiag] + rsub3[self.offdiag])

    def f(self, x):
        self._cache(x)
        return self._f

    def jac(self, x):
        self._cache(x)
        return self._jac


class OddSystem:
    def __init__(self, n):
        arange = np.arange(n, dtype=np.float64)
        self.sign = np.empty((n, n), dtype=np.float64)
        np.sign(np.subtract.outer(arange, arange, out=self.sign), out=self.sign)
        self.diag = np.diag_indices(n)
        self.offdiag = np.logical_not(np.eye(n, dtype=bool))
        self._last = None
        self._f = None
        self._jac = np.empty((n, n), dtype=np.float64)

    def f(self, x):
        self._cache(x)
        return self._f

    def jac(self, x):
        self._cache(x)
        return self._jac

    def _cache(self, x):
        x = np.array(x, dtype=np.float64, copy=False)
        if x is self._last:
            return
        self._last = x
        radd = 1 / np.add.outer(x, x)
        radd2 = radd**2
        radd3 = radd2 * radd
        sub = np.subtract.outer(x, x)
        rsub = np.empty_like(radd)
        rsub[self.diag] = 0
        rsub[self.offdiag] = 1 / sub[self.offdiag]
        rsub2 = self.sign * rsub**2
        rsub3 = rsub2 * rsub
        self._f = x - np.sum(radd2, axis=0) + np.sum(rsub2, axis=0) - 1 / (x**2)
        self._jac[self.diag] = 1 + 2*(radd3[self.diag] + np.sum(radd3[self.offdiag], axis=0) + np.sum(rsub3, axis=0) + 1 / (x**3))
        self._jac[self.offdiag] = 2 * radd3[self.offdiag] + 2 * rsub3[self.offdiag]


def eqms(n):
    sol = [np.array([np.cbrt(0.25)]), np.array([np.cbrt(1.25)])]
    for i in range(4, n+1):
        sys = EvenSystem(i//2) if i % 2 == 0 else OddSystem(i//2)
        x0 = np.hstack([(i - 1) / i * sol[-2], [2*sol[-2][0] + sol[-2][-1]]])
        x = scipy.optimize.fsolve(sys.f, x0, fprime=sys.jac, col_deriv=1)
        sol.append(x)
    out = [
        np.hstack([-x[::-1], x]) if i % 2 == 0 else np.hstack([-x[::-1], [0], x])
        for i, x in enumerate(sol)
    ]
    return out[:max(0, n-1)]


def eqms_table(n):
    sol = eqms(n)
    for i, x in enumerate(sol):
        out = ", ".join(f"{y: 9.6f}" if y != 0 else f"{0: 9d}" for y in x)
        end = "\\midrule" if i % 3 == 2  and i != len(sol) - 1 else ""
        print(rf"    \raisebox{{\cellbaseline}}{{{i+2:d}}} & \equilibriumdrawing{{{out}}}\\{end}%")


def _fix_mode(eqms_, mode):
    rightness = np.sum(mode)
    outness = np.sum(np.sign(eqms_) * mode)
    if rightness < -1e-3 or outness < -1e-3:
        return mode * -1
    return mode


def modes(eqms_):
    eqms_ = np.asarray(eqms_, dtype=np.float64)
    n = eqms_.shape[0]
    diag = np.diag_indices(n)
    offdiag = np.logical_not(np.eye(n, dtype=bool))
    out = np.eye(n, dtype=np.float64)
    rsub3 = np.zeros_like(out)
    rsub3[offdiag] = 2 / np.abs(np.subtract.outer(eqms_, eqms_)[offdiag])**3
    out[diag] += np.sum(rsub3, axis=1)
    out[offdiag] -= rsub3[offdiag]
    vals, vecs = np.linalg.eigh(out)
    return np.sqrt(vals), np.array([_fix_mode(eqms_, mode) for mode in vecs.T])

def modes_table(m):
    eqms_ = eqms(m)
    freq_modes = [modes(eqm) for eqm in eqms_]
    max_l, max_d = np.max(np.abs(eqms_[-1])), np.max(freq_modes[-1][1][:, -1])
    for n, eqm in zip(range(2, m+1), eqms_):
        drawings = [
            (
                r"\raisebox{\cellbaseline}{"
                + (r"$\sqrt3$" if np.abs(freq - np.sqrt(3)) < 1e-5 else r"\num{" + f"{freq:.6f}" + "}")
                + "} & "
                + rf"\modedrawing{{{max_l:.6f}}}{{{max_d:.6f}}}{{"
                + ", ".join(f"{loc:.6f}/{vel:.6f}" for loc, vel in zip(eqm, mode))
                + r"}"
            )
            for freq, mode in zip(*modes(eqm))
        ]
        if n == 2:
            vraise = ""
        else:
            vraise = f"[{n/2-1}\\cellbaseline-{n/2-1}\\cellheight]"
        pre = rf"\multirow{n}*{vraise}{n}"
        join = "\\\\%\n    " + " "*len(pre) + " & "
        print(rf"    {pre} & " + join.join(drawings) + r"\\" + (r"\midrule" if n != m else "") + "%")

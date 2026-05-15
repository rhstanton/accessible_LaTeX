# Convert a price series to log returns.
import numpy as np


def log_returns(prices):
    """Return ln(P_t / P_{t-1}) for a 1-D series."""
    return np.diff(np.log(prices))

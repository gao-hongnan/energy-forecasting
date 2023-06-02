from typing import TypeAlias, Tuple
import pandas as pd

TrainTestDataType: TypeAlias = Tuple[
    pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame
]

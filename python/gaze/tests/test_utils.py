import numpy as np
from numpy.testing import assert_array_equal
import gaze.utils as gu
import nose.tools as nt

def test_dataline_check():
    assert(gu.is_dataline("13214122       .       .        0.0    ..."))
    assert(not gu.is_dataline("MSG    4435590 DISPLAY_COORDS 0 0 1679 1049"))
    assert(gu.is_dataline("1"))
    assert(not gu.is_dataline(" 1"))

def test_line_conversion():
    # variable length line
    nt.assert_list_equal(gu.get_line_items("1 2 3 4 5"), [1, 2, 3])
    nt.assert_list_equal(gu.get_line_items("1 2 3 4"), [1, 2, 3])
    nt.assert_list_equal(gu.get_line_items("1 2 3"), [1, 2])
    # missing values
    nt.assert_list_equal(gu.get_line_items("1 . 3 4 5"), [1, np.nan, np.nan])
    nt.assert_list_equal(gu.get_line_items("1 2 . 4 5"), [1, np.nan, np.nan])
    nt.assert_list_equal(gu.get_line_items("1 . . . ."), [1, np.nan, np.nan])
    nt.assert_raises(ValueError, gu.get_line_items, ". 2 3 4 5")

def test_blink_removal():
    def stupid_but_simple_remove_blinks(data):
        filtered = []
        for samp in data:
            if not np.isnan(samp).sum():
                filtered.append(samp)
        return np.array(filtered)

    data1 = np.array([
        [1, 2, 2],
        [2, np.nan, np.nan],
        [3, 3, 4],
        [4, np.nan, np.nan]])

    assert_array_equal(stupid_but_simple_remove_blinks(data1),
                       [[1, 2, 2], [3, 3, 4]])
    assert_array_equal(stupid_but_simple_remove_blinks(data1),
                       gu.remove_blinks_arr(data1))

if __name__ == '__main__':
    test_dataline_check()

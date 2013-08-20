from os.path import join as opj
import numpy as np
from numpy.testing import assert_array_equal
import gaze.utils as gu

def test_gold_standard():
    # compare with gold-standard conversion -- needs to match exactly
    gold = np.load('hand_checked_gaze_data.npy')
    data = gu.load_data(opj('data', 'gaze.txt.gz'))
    assert_array_equal(gold, data)

if __name__ == '__main__':
    test_gold_standard()

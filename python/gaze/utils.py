import fileinput
import numpy as np
import pylab as pl

def is_dataline(lineno, line):
    return line[0].isdigit()

def get_line_items(line):
    items = line.split()[:-1]
    try:
        return [float(i) for i in items[:3]]
    except ValueError:
        return [float(items[0]), np.nan, np.nan]

def load_data_in(file_like):
    data = []
    for lineno, line in enumerate(file_like):
        if not is_dataline(lineno, line):
            continue
        data.append(get_line_items(line))
    return np.array(data)

def load_data(filename):
    fi = fileinput.FileInput(filename, openhook=fileinput.hook_compressed)
    return load_data_in(fi)

def remove_blinks_arr(data):
    blink = np.isnan(data[:,1])
    return data[np.logical_not(blink)]

def filter_data(data):
    d = remove_blinks_arr(data)
    np.clip(d[:, 1], 0, 1680, d[:, 1])
    np.clip(d[:, 2], 0, 1050, d[:, 2])
    return d

def make_heatmap_plot(x, y, bins=50, tick_step=5, interpolation='nearest'):
    """Plot spatial distribution of gaze coordinates

    This function cannot handle NaNs.

    Parameters
    ----------
    x : array
      x-coordinates
    y : array
      y-coordinates (need to match length of x-coordinates)
    bins : int
      number of histogram bins
    tick_steps : int
      step size for labeling bin boundaries (e.g. 1: reports all,
      5: labels every 5th)
    interpolation : str
      label of a supported interpolation method (e.g. 'bilinear', 'bicubic')
      default: nearest neighbor interpolation

    Returns
    -------
    fig
      a reference to the generated matplotlib figure
    """
    heatmap, xbound, ybound = np.histogram2d(x, y, bins=bins)
    fig = pl.figure()
    pl.imshow(heatmap, interpolation=interpolation)
    pl.xticks(np.arange(len(xbound))[::tick_step] - 0.5, xbound[::tick_step], rotation=90)
    pl.yticks(np.arange(len(ybound))[::tick_step] - 0.5 , ybound[::tick_step])
    return fig

import os
import re

_IDENTIFIER_START = "START OOO"
_IDENTIFIER_END = "END OOO"


def _expand(path):
    return os.path.expanduser(os.path.expandvars(path))


def write(filepath, content, comment_mark):
    filepath = _expand(filepath)
    if not os.path.isfile(filepath):
        # If file does not exist, do nothing but simply return the filepath
        return filepath
    else:
        with open(filepath, 'r+') as f:
            ori_con = f.read()
            leading = f'{comment_mark} {_IDENTIFIER_START}'
            ending = f'{comment_mark} {_IDENTIFIER_END}'
            m = re.sub(rf'^{leading}$.*^{ending}$',
                       os.linesep.join([leading, content, ending]),
                       ori_con,
                       flags=re.MULTILINE | re.DOTALL)
            f.seek(0)  # Move back the pointer
            f.write(m)
            f.truncate()  # Truncate the left (original) content in the file

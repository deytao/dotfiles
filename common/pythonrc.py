
try:
    import readline
except ImportError:
    print('Module readling not available')
else:
    import rlcompleter
    readline.parse_and_bind('tab: complete')

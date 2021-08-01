def one(wins):
    if 'Alacritty' in wins:
        return {
            'horizontal': 400,
            'vertical': 150
        }
    else:
        return {
            'horizontal': 100,
            'top': 40,
            'bottom': 25
        }


def two(wins):
    return {
        'horizontal': 50,
        'top': 40,
        'bottom': 25
    }


def rules(wins):
    if len(wins) == 1:
        return one(wins)
    elif len(wins) == 2:
        return two(wins)

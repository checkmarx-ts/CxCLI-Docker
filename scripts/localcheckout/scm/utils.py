

def indexof (value, argArray):
    try:
        return argArray.index(value)
    except ValueError:
        return None
        

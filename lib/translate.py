translations = {}

def load_translations(language):
    file_path = f'translations/{language}.txt'
    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            # Ignore empty lines
            if not line.strip():
                continue

            # Ignore lines starting with '#'
            if line.strip().startswith('#'):
                continue
                
            # Split the line into two parts using the '|' separator
            parts = line.strip().split('|')

            # Check if there are at least two parts
            if len(parts) >= 2:
                key, value = parts[0], '|'.join(parts[1:])
                translations[key] = value
            else:
                # Display a warning if a line cannot be correctly split
                print(f"Warning: Unable to split the line correctly: {line}")

def translate(message, language='en'):
    return translations.get(message, message)

def convert_snake_case_to_pascal(name: str) -> str:
    # split the string by underscore
    words = name.split("_")
    # capitalize the first letter of each word
    words = [word.capitalize() for word in words]

    delimiter = ""
    if "$" in name:
        delimiter = "_"

    # join the words
    name = delimiter.join(words)
    if "$" in name:
        name = name.replace("$", "")
    return name


if __name__ == "__main__":
    print(convert_snake_case_to_pascal("Cf$Reasonforlate"))

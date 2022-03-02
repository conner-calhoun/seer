package main

import "core:fmt"
import "core:os"
import "core:strings"

import path "core:path/slashpath"

seerfile : string


Commands :: enum {
    TO,
    REGISTER,
}

header :: proc() {
    fmt.println("------------- SEER -------------")
}

get_seerfile_data :: proc() -> string {
    data, _ := os.read_entire_file_from_filename(seerfile)
    // TODO: read into a map: key name, value path
    return string(data)
}

remember :: proc(dir_name: string, location: string) {
    // check if location exists
    // if yes, add it to the seerfile

    header()
    fmt.printf("Remembering {} as {}\n", dir_name, location)
}

ls :: proc() {
    // read seerfile and print each entry
    header()
    data := get_seerfile_data()
    for line in strings.split(data, "\n") {
        line_split := strings.split(line, " ")
        if len(line_split) == 2 do fmt.printf("{}: {}\n",line_split[0], line_split[1])
    }
}

go_to :: proc(dir: string) {
    // read seerfile into memory
    // look for 'dir' in the file
    // if it exists, cd there, otherwise tell the user it doesn't exist
    fmt.println("going to!")
    to_dir := "/d/programming/tools/seer/"
    os.change_directory(to_dir)
}

print_help :: proc() {
    header()
    fmt.println("  -h | --help      Prints the help message")
    fmt.println("  ls               Lists all the directories watched by seer")
    fmt.println("  rem <name> <dir> Remembers the directory using the given name")
}

main :: proc() {
    seerfile = path.join(path.dir(os.args[0]), "seerfile")

    if len(os.args) > 1 {
        switch(os.args[1]) {
            case "-h":
                print_help()
            case "--help":
                print_help()
            case "ls":
                ls()
            case "rem":
                if len(os.args) > 3 do remember(os.args[2], os.args[3])
            case:
                go_to(os.args[1])
        }
    } else {
        print_help()
    }
}

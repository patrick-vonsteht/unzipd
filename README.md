This script extracts the contents of a zip archive in a user-friendly way, 
whether the archive has a single root file/directory or multiple files at the 
root level.
  * If the archive contains just one root file or directory, the script 
    extracts it directly.
  * If the archive contains multiple files at the root level, the script 
    creates a subdirectory named after the archive and extracts all files into
    this subdirectory.

**Benefits**
* No need to manually check the archive’s structure.
* Avoids double nested directories.
* Prevents accidental extraction of multiple files into the current directory.

**Usage**

Extract the archive `my.zip` into a subdirectory of the current directory:
```
./unzipd.sh my.zip
```

**Implementation**

The script extracts the archive into a temporary directory at first. Then it
checks if there's a single root element or multiple root elements. If there's
a single root element, it copies that root element to the current directory.
If there are multiple root elements, it moves the whole temporary directory to
the current directory.

**Attributions**

This script is an improved version of the one presented in https://superuser.com/a/1414903, used under https://creativecommons.org/licenses/by-sa/4.0/. It is distributed under the same license. 

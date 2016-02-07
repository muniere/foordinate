# farrange

Utility commands to arrange files with Crystal (http://crystal-lang.org/)

## Requirements

- [Crsytal](http://crystal-lang.org/) >= 0.10.0
- [Rake](https://github.com/ruby/rake) >= 10.4.0

## Installation

```bash
# clone
$ git clone git@github.com:muniere/farrange.git

# install
$ cd farrange
$ ./configure --prefix=/usr/local
$ rake && rake install

# or only link
$ rake && rake link
```

## Usage

### Count entries in directory

```bash
# default
$ count dir1 dir2 dir3

# filter with pattern
$ count --pattern="*.txt" dir1 dir2 dir3

# include hidden files
$ count --all dir1 dir2
```

### Numberize filenames

```bash
# default
$ numberize *.jpg

# with options
$ numberize --start=1234 --length=4 --prefix="image_" *.jpg

# dry run
$ numberize -n *.jpg
```

### Randomize filenames

```bash
# default
$ randomize *.jpg

# with options
$ randomize --length=5 --prefix="image_" *.jpg

# dry run
$ randomize -n *.jpg
```


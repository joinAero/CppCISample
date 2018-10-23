# Sample C++ Project with CI

| Linux/macOS | Windows |
| ----------- | ------- |
| [![Build Status](https://travis-ci.com/joinAero/CppCISample.svg?branch=master)](https://travis-ci.com/joinAero/CppCISample) | [![Build status](https://ci.appveyor.com/api/projects/status/ngxl218bjykacn3m?svg=true)](https://ci.appveyor.com/project/joinAero/cppcisample) |

## Usage

```bash
git clone https://github.com/joinAero/CppCISample.git

cd CppCISample/
make init
make build

./_output/bin/imgui_demo
./_output/bin/nuklear_demo
```

`make help` to see more.

## Dependencies

* [imgui](https://github.com/ocornut/imgui), v1.65
* [Nuklear](https://github.com/vurtun/nuklear), 4.00.1

## References

*Articles:*

* [GitHub welcomes all CI tools](https://blog.github.com/2017-11-07-github-welcomes-all-ci-tools/)
* [Travis CI - Building a C++ Project](https://docs.travis-ci.com/user/languages/cpp/)
* [AppVeyor - Building C/C++ projects](https://www.appveyor.com/docs/lang/cpp/)

*Samples:*

* [ModernCppCI](https://github.com/LearningByExample/ModernCppCI)

## License

The project is [Apache License, Version 2.0](/LICENSE) licensed.

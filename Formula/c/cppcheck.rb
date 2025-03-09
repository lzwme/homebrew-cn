class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https:sourceforge.netprojectscppcheck"
  url "https:github.comdanmarcppcheckarchiverefstags2.17.1.tar.gz"
  sha256 "bfd681868248ec03855ca7c2aea7bcb1f39b8b18860d76aec805a92a967b966c"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comdanmarcppcheck.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "ec502cce12b5cbc573788773a08893844fc2320ab8340dca7d3f70bf3f25db97"
    sha256 arm64_sonoma:  "7f6a9c806b85dfa61ef9eae8d85d1592117fc54bf7dc1dfa3d6cf8e963221b80"
    sha256 arm64_ventura: "ef6c31e2c6048790a3ebba74b79a624267d53371b4701e96d164fd991f27abb5"
    sha256 sonoma:        "042af3302c0cf0ce060f8d52ceaa8217915ba96738bcfd2bc0eff817e263f60d"
    sha256 ventura:       "ecba5998fbfe4e801e7fb2b6c7378cdd35048eecba61cc51b3fae620bf0b2b01"
    sha256 x86_64_linux:  "1c5b977ee79e17bee1f8eed177c7c6dc93d1c20bfe9fa0806e4354e50f77de90"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "pcre"
  depends_on "tinyxml2"

  uses_from_macos "libxml2"

  def python3
    which("python3.13")
  end

  def install
    args = %W[
      -DHAVE_RULES=ON
      -DUSE_BUNDLED_TINYXML2=OFF
      -DENABLE_OSS_FUZZ=OFF
      -DPYTHON_EXECUTABLE=#{python3}
      -DFILESDIR=#{pkgshare}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Execution test with an input .cpp file
    test_cpp_file = testpath"test.cpp"
    test_cpp_file.write <<~CPP
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << "Hello World!" << endl;
        return 0;
      }

      class Example
      {
        public:
          int GetNumber() const;
          explicit Example(int initialNumber);
        private:
          int number;
      };

      Example::Example(int initialNumber)
      {
        number = initialNumber;
      }
    CPP
    system bin"cppcheck", test_cpp_file

    # Test the "out of bounds" check
    test_cpp_file_check = testpath"testcheck.cpp"
    test_cpp_file_check.write <<~CPP
      int main()
      {
        char a[10];
        a[10] = 0;
        return 0;
      }
    CPP
    output = shell_output("#{bin}cppcheck #{test_cpp_file_check} 2>&1")
    assert_match "out of bounds", output

    # Test the addon functionality: sampleaddon.py imports the cppcheckdata python
    # module and uses it to parse a cppcheck dump into an OOP structure. We then
    # check the correct number of detected tokens and function names.
    addons_dir = pkgshare"addons"
    cppcheck_module = "#{name}data"
    expect_token_count = 51
    expect_function_names = "main,GetNumber,Example"
    assert_parse_message = "Error: sampleaddon.py: failed: can't parse the #{name} dump."

    sample_addon_file = testpath"sampleaddon.py"
    sample_addon_file.write <<~PYTHON
      #!usrbinenv #{python3}
      """A simple test addon for #{name}, prints function names and token count"""
      import sys
      from importlib import machinery, util
      # Manually import the '#{cppcheck_module}' module
      spec = machinery.PathFinder().find_spec("#{cppcheck_module}", ["#{addons_dir}"])
      cpp_check_data = util.module_from_spec(spec)
      spec.loader.exec_module(cpp_check_data)

      for arg in sys.argv[1:]:
          # Parse the dump file generated by #{name}
          configKlass = cpp_check_data.parsedump(arg)
          if len(configKlass.configurations) == 0:
              sys.exit("#{assert_parse_message}") # Parse failure
          fConfig = configKlass.configurations[0]
          # Pick and join the function names in a string, separated by ','
          detected_functions = ','.join(fn.name for fn in fConfig.functions)
          detected_token_count = len(fConfig.tokenlist)
          # Print the function names on the first line and the token count on the second
          print("%s\\n%s" %(detected_functions, detected_token_count))
    PYTHON

    system bin"cppcheck", "--dump", test_cpp_file
    test_cpp_file_dump = "#{test_cpp_file}.dump"
    assert_path_exists testpathtest_cpp_file_dump
    output = shell_output("#{python3} #{sample_addon_file} #{test_cpp_file_dump}")
    assert_match "#{expect_function_names}\n#{expect_token_count}", output
  end
end
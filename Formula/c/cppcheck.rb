class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https:sourceforge.netprojectscppcheck"
  url "https:github.comdanmarcppcheckarchiverefstags2.14.1.tar.gz"
  sha256 "22d1403fbc3158f35b5216d7b0a50bbaf0c80bf6663933a71f65cc4fc307ff3d"
  license "GPL-3.0-or-later"
  head "https:github.comdanmarcppcheck.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "1663a4a75cddfa897bc0faad185207528e648d5c838c8718588e4b2b918bb36d"
    sha256 arm64_ventura:  "f8a257d35680038822dafb37e75d4de4cfea52ebe2b0b00639302062da2af12c"
    sha256 arm64_monterey: "48c72b79a27b4b87db7bbc87c1ca7f8feeafeda2b7eba6f3588eb8f62280e0a6"
    sha256 sonoma:         "cf2e1a1df1ca377c2a8cc4a855b3085e996f3d23f673e4d382af8c391d9872b3"
    sha256 ventura:        "8a83614a89a95cd4fdf621281eebbb97376fe6db935e2859fd5d22f16b62c4d5"
    sha256 monterey:       "10e4ad0c62e0f4088a4cc017ee01672904bca103b78740ddf47ccc9b258c530a"
    sha256 x86_64_linux:   "3d1847ff527e4e9161192bd9e3fd839b8ac3d5d5792ed63c463a105c7abbd083"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "pcre"
  depends_on "tinyxml2"

  uses_from_macos "libxml2"

  def python3
    which("python3.12")
  end

  def install
    args = std_cmake_args + %W[
      -DHAVE_RULES=ON
      -DUSE_BUNDLED_TINYXML2=OFF
      -DENABLE_OSS_FUZZ=OFF
      -DPYTHON_EXECUTABLE=#{python3}
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move the python addons to the cppcheck pkgshare folder
    (pkgshare"addons").install Dir.glob("addons*.py")
  end

  test do
    # Execution test with an input .cpp file
    test_cpp_file = testpath"test.cpp"
    test_cpp_file.write <<~EOS
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
    EOS
    system "#{bin}cppcheck", test_cpp_file

    # Test the "out of bounds" check
    test_cpp_file_check = testpath"testcheck.cpp"
    test_cpp_file_check.write <<~EOS
      int main()
      {
      char a[10];
      a[10] = 0;
      return 0;
      }
    EOS
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
    sample_addon_file.write <<~EOS
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
    EOS

    system "#{bin}cppcheck", "--dump", test_cpp_file
    test_cpp_file_dump = "#{test_cpp_file}.dump"
    assert_predicate testpathtest_cpp_file_dump, :exist?
    output = shell_output("#{python3} #{sample_addon_file} #{test_cpp_file_dump}")
    assert_match "#{expect_function_names}\n#{expect_token_count}", output
  end
end
class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https:sourceforge.netprojectscppcheck"
  url "https:github.comdanmarcppcheckarchiverefstags2.13.0.tar.gz"
  sha256 "8229afe1dddc3ed893248b8a723b428dc221ea014fbc76e6289840857c03d450"
  license "GPL-3.0-or-later"
  head "https:github.comdanmarcppcheck.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "2a555aa437686f0449cb1ff2c84a9fff93c98e453ada241841ab70f111f7d9f1"
    sha256 arm64_ventura:  "c08f0e6190f4860275ae8f8d411507689fbc18eb321fd26ed853ecf37e1bd6ab"
    sha256 arm64_monterey: "2fca9c884b17411522042a0a8e4dd2c889220d7a7e099a59022c36be38cada0c"
    sha256 sonoma:         "3db2ed94f2c1234f9a46ba33725b17c226308e729453e3d9cd0957c1c35e596f"
    sha256 ventura:        "d3aa84ed21f699b08ceda2ea5742a69d74f1e5cace04fe6c761ec41c1ad0ec6d"
    sha256 monterey:       "6d6d351294579c67a0cf6ac0de678ab81f2804cb4efd45c0dd351002ac04670c"
    sha256 x86_64_linux:   "a3b3bf0bd34e29c3bda88c68ea97dfb11818c0cc4ef20f87349326f560324caa"
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
      -DUSE_MATCHCOMPILER=ON
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
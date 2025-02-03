class Nanobind < Formula
  desc "Tiny and efficient C++Python bindings"
  homepage "https:github.comwjakobnanobind"
  url "https:github.comwjakobnanobindarchiverefstagsv2.5.0.tar.gz"
  sha256 "acb2e1997c44f2c79f510c66e7ff9f4cac0502e9fe275ebc7af7571e869f8df0"
  license "BSD-3-Clause"
  head "https:github.comwjakobnanobind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f217b7c808ca6930b728a727fb3393c2876c1a289d13077a149adf2e3b612e39"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "robin-map" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNB_USE_SUBMODULE_DEPS=OFF",
                    "-DNB_CREATE_INSTALL_RULES=ON",
                    "-DNB_INSTALL_DATADIR=#{pkgshare}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    python_versions = Formula.names
                             .select { |name| name.start_with? "python@" }
                             .map { |py| Version.new(py.delete_prefix("python@")) }
    python_versions.each do |pyver|
      site_packages = lib"python#{pyver}site-packages"
      site_packages.install_symlink pkgshare
    end
  end

  test do
    python = "python3.13"

    (testpath"my_ext.cpp").write <<~CPP
      #include <nanobindnanobind.h>

      int add(int a, int b) { return a + b; }

      NB_MODULE(my_ext, m) {
          m.def("add", &add);
      }
    CPP

    python_version = Language::Python.major_minor_version(python)

    cmakelists = testpath"CMakeLists.txt"
    cmakelists.write <<~CMAKE
      cmake_minimum_required(VERSION 3.27)
      project(test_nanobind)

      find_package(Python #{python_version} COMPONENTS Interpreter Development.Module REQUIRED)

      if(FIND_NANOBIND_USING_PYTHON)
        execute_process(
          COMMAND "${Python_EXECUTABLE}" -m nanobind --cmake_dir
          OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE nanobind_ROOT COMMAND_ERROR_IS_FATAL ANY)
      endif()
      find_package(nanobind CONFIG REQUIRED)
      nanobind_add_module(my_ext my_ext.cpp)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", "-DFIND_NANOBIND_USING_PYTHON=OFF", *std_cmake_args
    system "cmake", "--build", "build"

    cd "build" do
      assert_equal "3", shell_output("#{python} -c 'import my_ext; print(my_ext.add(1, 2))'").chomp
    end

    ENV.delete("CMAKE_PREFIX_PATH")
    prefix_path_dirs = deps.filter_map { |dep| dep.to_formula.opt_prefix if !dep.build? || dep.test? }
    cmake_find_args = %W[
      -DCMAKE_MAKE_PROGRAM=make
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_PREFIX_PATH='#{prefix_path_dirs.join(";")}'
      -DCMAKE_FIND_USE_CMAKE_SYSTEM_PATH=OFF
      -DCMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH=OFF
    ]
    # Ensure that nanobind can by found only using `python3 -m nanobind`.
    cmake_failure = "cmake -S . -B build-failure #{cmake_find_args.join(" ")} 2>&1"
    assert_match 'Could not find a package configuration file provided by "nanobind"', shell_output(cmake_failure, 1)

    system "cmake", "-S", ".", "-B", "build-python",
                    "-DFIND_NANOBIND_USING_PYTHON=ON",
                    *cmake_find_args, *std_cmake_args
    system "cmake", "--build", "build-python"

    cd "build-python" do
      assert_equal "3", shell_output("#{python} -c 'import my_ext; print(my_ext.add(1, 2))'").chomp
    end
  end
end
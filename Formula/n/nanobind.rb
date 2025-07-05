class Nanobind < Formula
  desc "Tiny and efficient C++/Python bindings"
  homepage "https://github.com/wjakob/nanobind"
  url "https://ghfast.top/https://github.com/wjakob/nanobind/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "6c8c6bf0435b9d8da9312801686affcf34b6dbba142db60feec8d8e220830499"
  license "BSD-3-Clause"
  head "https://github.com/wjakob/nanobind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27262487a8a0bb8435e7652f543f2058057b1c7f5d3d71f36fd3c2cf1f34bcba"
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
      site_packages = lib/"python#{pyver}/site-packages"
      site_packages.install_symlink pkgshare
    end
  end

  test do
    python = "python3.13"

    (testpath/"my_ext.cpp").write <<~CPP
      #include <nanobind/nanobind.h>

      int add(int a, int b) { return a + b; }

      NB_MODULE(my_ext, m) {
          m.def("add", &add);
      }
    CPP

    python_version = Language::Python.major_minor_version(python)

    cmakelists = testpath/"CMakeLists.txt"
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
class Nanobind < Formula
  desc "Tiny and efficient C++Python bindings"
  homepage "https:github.comwjakobnanobind"
  url "https:github.comwjakobnanobindarchiverefstagsv2.1.0.tar.gz"
  sha256 "c37c53c60ada5fe1c956e24bd4b83af669a2309bf952bd251f36a7d2fa3bacf0"
  license "BSD-3-Clause"
  head "https:github.comwjakobnanobind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67d3bc9718d09845035fdb44fa3ac8e60e80bcc8170900f25a945589eeb02e9d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
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
    python = "python3.12"

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
      find_package(nanobind CONFIG REQUIRED)
      nanobind_add_module(my_ext my_ext.cpp)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    cd "build" do
      assert_equal "3", shell_output("#{python} -c 'import my_ext; print(my_ext.add(1, 2))'").chomp
    end

    ENV.delete("CMAKE_PREFIX_PATH")
    cmakelists.unlink
    cmakelists.write <<~CMAKE
      cmake_minimum_required(VERSION 3.27)
      project(test_nanobind)

      # Ensure that nanobind can be found only via `execute_process` below.
      set(CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH FALSE)
      set(CMAKE_FIND_USE_CMAKE_SYSTEM_PATH FALSE)
      find_package(Python #{python_version} COMPONENTS Interpreter Development.Module REQUIRED)
      execute_process(
        COMMAND "${Python_EXECUTABLE}" -m nanobind --cmake_dir
        OUTPUT_STRIP_TRAILING_WHITESPACE OUTPUT_VARIABLE nanobind_ROOT COMMAND_ERROR_IS_FATAL ANY)
      find_package(nanobind CONFIG REQUIRED)
      nanobind_add_module(my_ext my_ext.cpp)
    CMAKE

    prefix_path_dirs = deps.filter_map { |dep| dep.to_formula.opt_prefix if !dep.build? || dep.test? }
    system "cmake", "-S", ".", "-B", "build-python",
                    "-DCMAKE_PREFIX_PATH=#{prefix_path_dirs.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build-python"

    cd "build-python" do
      assert_equal "3", shell_output("#{python} -c 'import my_ext; print(my_ext.add(1, 2))'").chomp
    end
  end
end
class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https:github.compybindpybind11"
  url "https:github.compybindpybind11archiverefstagsv2.13.5.tar.gz"
  sha256 "b1e209c42b3a9ed74da3e0b25a4f4cd478d89d5efbb48f04b277df427faf6252"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "60413ac82c90391d1ec75248efe6b31155fd1109590a92417d4df78d78cc4729"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(^python@3\.\d+$) }
  end

  def install
    # Install include and sharecmake to the global location
    system "cmake", "-S", ".", "-B", "build", "-DPYBIND11_TEST=OFF", "-DPYBIND11_NOPYTHON=ON", *std_cmake_args
    system "cmake", "--install", "build"

    # build an `:all` bottle.
    inreplace share"cmakepybind11FindPythonLibsNew.cmake", "usrlocal", HOMEBREW_PREFIX
    inreplace share"pkgconfigpybind11.pc", ^prefix=$, "\\0#{opt_prefix}"

    pythons.each do |python|
      # Install Python package too
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      (buildpath"pybind11-config-#{pyversion}").write <<~BASH
        #!binbash
        exec -a "$0" "#{python.opt_bin}python#{pyversion}" -m pybind11 "$@"
      BASH
      chmod "+x", "pybind11-config-#{pyversion}"
      bin.install "pybind11-config-#{pyversion}"

      site_packages_pybind11 = prefixLanguage::Python.site_packages(python_exe)"pybind11"

      # Avoid installing duplicate files from the prefix
      site_packages_share = site_packages_pybind11"share"
      rm_r site_packages_share.children
      site_packages_share.install_symlink share.children

      site_packages_include = site_packages_pybind11"include"
      rm_r site_packages_include
      site_packages_include.install_symlink include.children

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pybind11-config-#{pyversion}" => "pybind11-config"
    end
  end

  test do
    (testpath"example.cpp").write <<~EOS
      #include <pybind11pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      pyversion = Language::Python.major_minor_version(python_exe)
      site_packages = Language::Python.site_packages(python_exe)

      python_flags = Utils.safe_popen_read(
        python.opt_libexec"binpython-config",
        "--cflags",
        "--ldflags",
        "--embed",
      ).split
      system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
      system python_exe, "example.py"

      test_module = shell_output(
        "#{python_exe} -m pybind11 --includes",
      ).chomp.gsub(python.opt_prefix.to_s, HOMEBREW_PREFIX.to_s)
      assert_match (HOMEBREW_PREFIXsite_packages"pybind11").to_s, test_module

      test_script = shell_output(
        "#{bin}pybind11-config-#{pyversion} --includes",
      ).chomp.gsub(python.opt_prefix.to_s, HOMEBREW_PREFIX.to_s)
      assert_equal test_module, test_script

      next if python != pythons.max_by(&:version)

      test_module = shell_output(
        "#{python_exe} -m pybind11 --includes",
      ).chomp.gsub(python.opt_prefix.to_s, HOMEBREW_PREFIX.to_s)
      test_script = shell_output(
        "#{bin}pybind11-config --includes",
      ).chomp.gsub(python.opt_prefix.to_s, HOMEBREW_PREFIX.to_s)
      assert_equal test_module, test_script
    end
  end
end
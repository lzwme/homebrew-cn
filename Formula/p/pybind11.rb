class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https:github.compybindpybind11"
  url "https:github.compybindpybind11archiverefstagsv2.13.3.tar.gz"
  sha256 "6e7a84ec241544f2f5e30c7a82c09c81f0541dd14e9d9ef61051e07105f9c445"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06e876728026edfec00758088d0f1ff8e909a6dd5304103a8dfac4ca4da373dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06e876728026edfec00758088d0f1ff8e909a6dd5304103a8dfac4ca4da373dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e876728026edfec00758088d0f1ff8e909a6dd5304103a8dfac4ca4da373dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "27db22e3823abba4f9f6719d3beadeac7d28ee72874d4d3b04eec7258c72bf73"
    sha256 cellar: :any_skip_relocation, ventura:        "27db22e3823abba4f9f6719d3beadeac7d28ee72874d4d3b04eec7258c72bf73"
    sha256 cellar: :any_skip_relocation, monterey:       "27db22e3823abba4f9f6719d3beadeac7d28ee72874d4d3b04eec7258c72bf73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e876728026edfec00758088d0f1ff8e909a6dd5304103a8dfac4ca4da373dc"
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

    pythons.each do |python|
      # Install Python package too
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexecsite_packages}')\n"
      (prefixsite_packages"homebrew-pybind11.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install libexec"binpybind11-config" => "pybind11-config-#{pyversion}"

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

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      assert_match (libexecsite_packages).to_s, test_module

      test_script = shell_output("#{bin}pybind11-config-#{pyversion} --includes")
      assert_match test_module, test_script

      next if python != pythons.max_by(&:version)

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      test_script = shell_output("#{bin}pybind11-config --includes")
      assert_match test_module, test_script
    end
  end
end
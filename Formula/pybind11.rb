class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://ghproxy.com/https://github.com/pybind/pybind11/archive/v2.11.0.tar.gz"
  sha256 "7af30a84c6810e721829c4646e31927af9d8861e085aa5dd37c3c8b8169fcda1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "900e6251cdff5ebee78c051c21a315a4bde096dc02a23b6fa4768e5be8d18ba2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900e6251cdff5ebee78c051c21a315a4bde096dc02a23b6fa4768e5be8d18ba2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "900e6251cdff5ebee78c051c21a315a4bde096dc02a23b6fa4768e5be8d18ba2"
    sha256 cellar: :any_skip_relocation, ventura:        "4624854705043c6e2298be382c3d36e2a0dfad06b6967ff21e64b1ebb4d16fb5"
    sha256 cellar: :any_skip_relocation, monterey:       "4624854705043c6e2298be382c3d36e2a0dfad06b6967ff21e64b1ebb4d16fb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4624854705043c6e2298be382c3d36e2a0dfad06b6967ff21e64b1ebb4d16fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900e6251cdff5ebee78c051c21a315a4bde096dc02a23b6fa4768e5be8d18ba2"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@3\.\d+$/) }
  end

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build", "-DPYBIND11_TEST=OFF", "-DPYBIND11_NOPYTHON=ON", *std_cmake_args
    system "cmake", "--install", "build"

    pythons.each do |python|
      # Install Python package too
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, *Language::Python.setup_install_args(libexec, python_exe)

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install libexec/"bin/pybind11-config" => "pybind11-config-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pybind11-config-#{pyversion}" => "pybind11-config"
    end
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)
      site_packages = Language::Python.site_packages(python_exe)

      python_flags = Utils.safe_popen_read(
        python.opt_libexec/"bin/python-config",
        "--cflags",
        "--ldflags",
        "--embed",
      ).split
      system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
      system python_exe, "example.py"

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      assert_match (libexec/site_packages).to_s, test_module

      test_script = shell_output("#{bin}/pybind11-config-#{pyversion} --includes")
      assert_match test_module, test_script

      next if python != pythons.max_by(&:version)

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      test_script = shell_output("#{bin}/pybind11-config --includes")
      assert_match test_module, test_script
    end
  end
end
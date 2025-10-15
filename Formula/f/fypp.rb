class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/01/35/0e2dfffc90201f17436d3416f8d5c8b00e2187e410ec899bb62cf2cea59b/fypp-3.2.tar.gz"
  sha256 "05c20f71dd9a7206ffe2d8688032723f97b8c2984d472ba045819d7d2b513bce"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "main"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "3de4ca648895c9fdec45f2a052785fb54b9b5db303574558d9ba5eb8d2f7940f"
  end

  depends_on "gcc" => :test
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    system bin/"fypp", "--version"

    (testpath/"test_fypp.py").write <<~PYTHON
      import fypp
      print("fypp version:", fypp.VERSION)
    PYTHON
    system python3, testpath/"test_fypp.py"

    (testpath/"hello.F90").write <<~EOS
      program hello
      #:for val in [_SYSTEM_, _MACHINE_, _FILE_, _LINE_]
        print *, '${val}$'
      #:endfor
      end
    EOS

    system bin/"fypp", testpath/"hello.F90", testpath/"hello.f90"
    ENV.fortran
    system ENV.fc, testpath/"hello.f90", "-o", testpath/"hello"
    system testpath/"hello"
  end
end
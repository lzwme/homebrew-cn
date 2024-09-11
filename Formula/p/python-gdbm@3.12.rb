class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.6/Python-3.12.6.tgz"
  sha256 "85a4c1be906d20e5c5a69f2466b00da769c221d6a684acfd3a514dbf5bf10a66"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "35da9ab64a4f626fd7f4d862de865e4f26094b2459132cd12d2492180e288964"
    sha256 cellar: :any, arm64_sonoma:   "7840935d50b840a039907e356c2b19fb27b54190a7923be1b875c13156dd4258"
    sha256 cellar: :any, arm64_ventura:  "a58e8902545870fd5e8b3181e0303fd02d63af118bf2ab590a6272616359e17f"
    sha256 cellar: :any, arm64_monterey: "417c663088633599d2b539b77a54950a12609f31405c097b372ad87f4ee22883"
    sha256 cellar: :any, sonoma:         "d224856bf9801734163247d920a7d3ccec2fad437aae0ec63eb64b987054b647"
    sha256 cellar: :any, ventura:        "41df5b3e11d4a427de35451a8bc4246262e9a9d2479c059767b7a2b973cb6e06"
    sha256 cellar: :any, monterey:       "5bd51319db598aec79aa28420cabec54306473cbbf3be720bf76dc75dcc158ec"
    sha256               x86_64_linux:   "86e4ff50ab0402ef77777535cedcfad5f8f0c11cd0065e5572f204f7c8bb88d8"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{Formula["gdbm"].opt_include}"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
              ]
        )
      EOS
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~EOS
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    EOS
  end
end
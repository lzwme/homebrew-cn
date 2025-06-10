class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.4/Python-3.13.4.tgz"
  sha256 "2666038f1521b7a8ec34bf2997b363778118d6f3979282c93723e872bcd464e0"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "14287cbfb4e16a63526e7770551e1ce11fbc23891a89ecd7a90c40527afd37ed"
    sha256 cellar: :any, arm64_sonoma:  "80225d70cf114a82f4be941f5e7b6987956b859556e8c8fa784f0d35f5e0131b"
    sha256 cellar: :any, arm64_ventura: "36ae9e96076f2eab24b4948f0a01a3aee630306b76a6efb7fe686762e19d02e7"
    sha256 cellar: :any, sonoma:        "23e91f623df059f185a587d176a988dd949ac9acb2681fd5b4e5145304af03fd"
    sha256 cellar: :any, ventura:       "3f915a5d880a7ecc1950a1c3453b28e4c930759a5428b4068d541a4bcd35db5c"
    sha256               arm64_linux:   "28c0a40f0c391073dcf2f1e87ea3986b0dd123a5e1fb123bccec52084bd54382"
    sha256               x86_64_linux:  "eb1440b801abca806ee6b04c208a9a9c1868bdbff0962ad45bc6509aadc14093"
  end

  depends_on "gdbm"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~PYTHON
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    PYTHON
  end
end
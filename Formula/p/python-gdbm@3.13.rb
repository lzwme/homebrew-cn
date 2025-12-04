class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.10/Python-3.13.10.tgz"
  sha256 "de5930852e95ba8c17b56548e04648470356ac47f7506014664f8f510d7bd61b"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e196b74a0699e8123e0d6761716b9ab52e1d07a403b4479082950aca9c31cf08"
    sha256 cellar: :any, arm64_sequoia: "62f7785f7fa440cafb1038f9081ba341baa2c842b385827bd1460444562c1f56"
    sha256 cellar: :any, arm64_sonoma:  "589adf768ed3a113dbd29f75fd475ce62dab01590a22fe02f4f66c108fbd65af"
    sha256 cellar: :any, sonoma:        "58f2007374a89be05c2a7d705bef3ba9eb4970819638290879eaf9cb92a0929a"
    sha256               arm64_linux:   "adf1770c8e9524ff00f91778b628394472088b92453c322b12fb56b9f10e2317"
    sha256               x86_64_linux:  "854162ecef001b9a15784d2045abf692e72703300a06ce4774978ae8cfad554a"
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
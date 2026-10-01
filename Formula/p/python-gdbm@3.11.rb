class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.17/Python-3.11.17.tgz"
  sha256 "53cdee63ac4bf12387b7b33a53d3b1f8f4941cad73807a7b4fe91bb001ef004a"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bac8d541df8cf5958a0f303fced3f26f9186cfd40a8e5b34d9928c295825c732"
    sha256 cellar: :any, arm64_tahoe:       "914429e663a83f2e3adca7c88236da1f5b198204a25ade835f9c7c2576cdbf63"
    sha256 cellar: :any, arm64_sequoia:     "40d17d96679c530def977be4d1e32aa32673366253621796cb2644f58eaccfd2"
    sha256               arm64_linux:       "be57e023828b4708e55b90c364efb684c71911723ceac717cd8036be0ba06c4e"
    sha256               x86_64_linux:      "35785aa439e9b5d70a4c148d41738535b2f9357f37e2e3cfc53e4fcf42e499b7"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2027-11-01", because: :deprecated_upstream
  disable! date: "2028-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.11"

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{formula_opt_include("gdbm")}"],
                          libraries=["gdbm"],
                          library_dirs=["#{formula_opt_lib("gdbm")}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
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
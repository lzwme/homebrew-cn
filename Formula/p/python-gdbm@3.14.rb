class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.9/Python-3.14.9.tgz"
  sha256 "8b47e85ee67e93945e93620a051a8f44bfc1e9735ed67075d166f4a74b7a060b"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "013e49daad0d454eeccb8a543a83647eff22517a1a5202601ca5ebfa2f9d3be1"
    sha256 cellar: :any, arm64_tahoe:       "6fb56456ca82c64bc0a6212af5697c332ed0006b4641f9aa2380fbb685440fb7"
    sha256 cellar: :any, arm64_sequoia:     "60866ea14d1862d0b8eb88d5e40be35e1f096ddd974f2319ce7dc719dc1c85da"
    sha256               arm64_linux:       "e2d39357c6b4c8609cd66f2fb66fbf7fd036d354aeced9aa2087d939362249e3"
    sha256               x86_64_linux:      "89788e65954e4ff8c2d8cd7ca9487a1b4aba5eed7ed603353c601453074b9729"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2030-11-01", because: :deprecated_upstream
  disable! date: "2031-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.14"

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
    end

    (buildpath/"Modules/pyproject.toml").write <<~TOML
      [project]
      name = "gdbm"
      version = "#{version}"
      description = "#{desc}"

      [tool.setuptools]
      packages = []

      [[tool.setuptools.ext-modules]]
      name = "_gdbm"
      sources = ["_gdbmmodule.c"]
      include-dirs = ["#{formula_opt_include("gdbm")}", "#{python_include}/internal"]
      libraries = ["gdbm"]
      library-dirs = ["#{formula_opt_lib("gdbm")}"]
    TOML

    (buildpath/"Modules/pyproject.toml").append_lines <<~TOML if OS.linux?
      [[tool.setuptools.ext-modules]]
      name = "_dbm"
      sources = ["_dbmmodule.c"]
      include-dirs = ["#{formula_opt_include("gdbm")}", "#{python_include}/internal"]
      libraries = ["gdbm_compat"]
      library-dirs = ["#{formula_opt_lib("gdbm")}"]
      extra-compile-args = ["-DUSE_GDBM_COMPAT", "-DHAVE_GDBM_DASH_NDBM_H"]
    TOML

    system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                            "--target=#{libexec}", "./Modules"
    rm_r libexec.glob("*.dist-info")
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

    return unless OS.linux?

    (testpath/"dbm_test.py").write <<~PYTHON
      import dbm

      with dbm.ndbm.open("test", "c") as db:
        db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
        assert list(db.keys()) == [b"foo \\xbd"]
        assert b"foo \\xbd" in db
        assert db[b"foo \\xbd"] == b"bar \\xbd"
    PYTHON
    system python3, "dbm_test.py"
  end
end
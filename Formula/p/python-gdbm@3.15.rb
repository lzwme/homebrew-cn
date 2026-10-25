class PythonGdbmAT315 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.15.1/Python-3.15.1.tgz"
  sha256 "133d85e118dc32621cda1d9d1d7d9694fe0c5e82bc339a7d528c109fe8b36387"
  license "Python-2.0"

  livecheck do
    formula "python@3.15"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "508034f773b2debb7a996e35faa3d128841e0d85ffb2b327a4130fa054bf7cdf"
    sha256 cellar: :any, arm64_tahoe:       "cbab3d3893dc47a5dfedb8b2b4d2967bef370e071ea5368f241204cdc9f6f362"
    sha256 cellar: :any, arm64_sequoia:     "702c7f799d3c67e35ea3c4b674f821f668d56cd02493ed17435df917993c4863"
    sha256               arm64_linux:       "8075fbc93f4a5e998b03ac0d462b4f96b70db8693c440ed698263869dddf38b1"
    sha256               x86_64_linux:      "56487ecbfc4a7c84123f573531127abb8c24199321a67b08f48b15d86452d9ae"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2031-11-01", because: :deprecated_upstream
  disable! date: "2032-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.15"

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
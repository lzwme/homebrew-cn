class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.6/Python-3.13.6.tgz"
  sha256 "6cf50672cc03928488817d45af24bc927a48f910fe7893d6f388130e59ba98d7"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "eff922a52278695729ec3cdab2fa0ef210d296319e430d63981d8aa5a97715e5"
    sha256 cellar: :any, arm64_sonoma:  "bb157c02fb229995c8fa710ac6e0e1ee02e0c241058b83e826c4b9042722c23f"
    sha256 cellar: :any, arm64_ventura: "da4c88f0f9c1ce2d7cb2f6c178438bc5a5574497c79f109aab2705203948434e"
    sha256 cellar: :any, sonoma:        "a0cabe302464063ea50f9917c0f302c7e05ae0b45f7d13444a72f8049ca94465"
    sha256 cellar: :any, ventura:       "99f9ec151efeddcca087b6f7dd11694f6fed48e10e4d807f68fb88069d1aec6b"
    sha256               arm64_linux:   "b9959b85da6bdf13504547db1e2811c8f129f4dda3bd0d596cf5ec728caddcb0"
    sha256               x86_64_linux:  "d9104c869d8e63d2e1f0d1a7bc8e7ce482ee4d2d60863ac7fd3eafd652abd0ea"
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
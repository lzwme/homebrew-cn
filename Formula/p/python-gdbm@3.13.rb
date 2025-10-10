class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.8/Python-3.13.8.tgz"
  sha256 "06108fe96f4089b7d9e0096cb4ca9c81ddcd5135f779a7de94cf59abcaa4b53f"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "21377761c23b9b09dc14029728cc015b3cbfe48408ed60b0c86cafdf6626751b"
    sha256 cellar: :any, arm64_sequoia: "2821e8f52b8a208c426669b7883d4399094420562217b89a31e8d33be7cc5f58"
    sha256 cellar: :any, arm64_sonoma:  "18b4fd3f4d81fcf6036473a85849cb0f383257d005e3c80ff22c5f0182c94ace"
    sha256 cellar: :any, sonoma:        "be766f94e55eb6a21a18b4d456f8f3f50a4f8f083623a58c9364915fb7a322de"
    sha256               arm64_linux:   "d93ac3ceaf032842913ffc0d22ad5d9c148343bf8990a342a434385ea80d6780"
    sha256               x86_64_linux:  "1f7fa493b31c8e92352a9986546cf931c6d3f9641e8683839ae65eb4f36fe268"
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
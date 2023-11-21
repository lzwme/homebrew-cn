class PythonMatplotlib < Formula
  desc "Python library for creating static, animated, and interactive visualizations"
  homepage "https://matplotlib.org/"
  url "https://files.pythonhosted.org/packages/fb/ab/38a0e94cb01dacb50f06957c2bed1c83b8f9dac6618988a37b2487862944/matplotlib-3.8.2.tar.gz"
  sha256 "01a978b871b881ee76017152f1f1a0cbf6bd5f7b8ff8c96df0df1bd57d8755a1"
  license "PSF-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f87a007e183b78fa45896bac75b13b200578b4c6f6050936276aa96124bbf9f1"
    sha256 cellar: :any,                 arm64_ventura:  "ee20b0c03a2e716a921094c99cf80389bf93a420239d240fa510e2e889ba9806"
    sha256 cellar: :any,                 arm64_monterey: "6e2e71a8fbbe29b1ab69bfb55db81fdd54df60ae3daede8f68602cd9cb28dc6d"
    sha256 cellar: :any,                 sonoma:         "93462a6519a47d5a5081757e8789b4db91d558ef75aa5e770cb0d4a0f04ef35e"
    sha256 cellar: :any,                 ventura:        "bbc45a72ffecf6b32dd83f9f11d8409a377f84b872b5810093e9ed42f759bbba"
    sha256 cellar: :any,                 monterey:       "7695df8adadd3e9d16acfaae8b187535ea64fb966abd17abe804d9e72b1993a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5c3878e5809e6b57c432f52deb5717c465be6715e400837aa770f9e32e432e"
  end

  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pybind11" => :build
  depends_on "python-certifi" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "fonttools"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-cycler"
  depends_on "python-dateutil"
  depends_on "python-kiwisolver"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "six"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :gcc do
    version "6"
    cause "Requires C++17 compiler"
  end

  resource "contourpy" do
    url "https://files.pythonhosted.org/packages/11/a3/48ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1/contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  def python3
    which("python3.12")
  end

  def install
    resource("contourpy").stage do
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end

    (buildpath/"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    backend = shell_output("#{python3} -c 'import matplotlib; print(matplotlib.get_backend())'").chomp
    assert_equal OS.mac? ? "MacOSX" : "agg", backend
  end
end
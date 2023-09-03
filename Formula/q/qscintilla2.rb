class Qscintilla2 < Formula
  desc "Port to Qt of the Scintilla editing component"
  homepage "https://www.riverbankcomputing.com/software/qscintilla/intro"
  url "https://www.riverbankcomputing.com/static/Downloads/QScintilla/2.14.1/QScintilla_src-2.14.1.tar.gz"
  sha256 "dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d"
  license "GPL-3.0-only"
  revision 1

  # The downloads page also lists pre-release versions, which use the same file
  # name format as stable versions. The only difference is that files for
  # stable versions are kept in corresponding version subdirectories and
  # pre-release files are in the parent QScintilla directory. The regex below
  # omits pre-release versions by only matching tarballs in a version directory.
  livecheck do
    url "https://www.riverbankcomputing.com/software/qscintilla/download"
    regex(%r{href=.*?QScintilla/v?\d+(?:\.\d+)+/QScintilla(?:[._-](?:gpl|src))?[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d34650d1b726d21185ea54d3067080e4cd8501beaeebf71c6be1be801ccb07d4"
    sha256 cellar: :any,                 arm64_monterey: "f0b7e7b76f802f1c65c26700701d1111ca6cf23bdd93fb505f7b37f7ec36e691"
    sha256 cellar: :any,                 arm64_big_sur:  "fc4dcf4f8d283d42eb333177c592278be165400dffa90dcb79cb7d9e6643d45e"
    sha256 cellar: :any,                 ventura:        "235fbda31e95d0aad423e78df07005322cf0758faaf219f1ff16fe640de7023d"
    sha256 cellar: :any,                 monterey:       "b3bd7a1cf1311ccfcc9fac651acd206de17d92543ba473b025e23881e069d97d"
    sha256 cellar: :any,                 big_sur:        "01d81d87353c9916cbe8bed2bdb2a88150ff657b82842e35958da8b8a55b80e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bced96a1cbe82f4a1557fd1f5089700f349e56a5792706d7a6a2275a448019c1"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "pyqt"
  depends_on "python@3.11"
  depends_on "qt"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    args = []

    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    pyqt = Formula["pyqt"]
    qt = Formula["qt"]
    site_packages = Language::Python.site_packages(python3)

    cd "src" do
      inreplace "qscintilla.pro" do |s|
        s.gsub! "QMAKE_POST_LINK += install_name_tool -id @rpath/$(TARGET1) $(TARGET)",
          "QMAKE_POST_LINK += install_name_tool -id #{lib}/$(TARGET1) $(TARGET)"
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
        s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", share/"qt/translations"
        s.gsub! "$$[QT_INSTALL_DATA]", share/"qt"
        s.gsub! "$$[QT_HOST_DATA]", share/"qt"
      end

      inreplace "features/qscintilla2.prf" do |s|
        s.gsub! "$$[QT_INSTALL_LIBS]", lib
        s.gsub! "$$[QT_INSTALL_HEADERS]", include
      end

      system qt.opt_bin/"qmake", "qscintilla.pro", *args
      system "make"
      system "make", "install"
    end

    cd "Python" do
      mv "pyproject-qt#{qt.version.major}.toml", "pyproject.toml"
      (buildpath/"Python/pyproject.toml").append_lines <<~EOS
        [tool.sip.project]
        sip-include-dirs = ["#{pyqt.opt_prefix/site_packages}/PyQt#{pyqt.version.major}/bindings"]
      EOS

      args = %W[
        --target-dir #{prefix/site_packages}

        --qsci-features-dir #{share}/qt/mkspecs/features
        --qsci-include-dir #{include}
        --qsci-library-dir #{lib}
        --api-dir #{share}/qt/qsci/api/python
      ]
      system "sip-install", *args
    end
  end

  test do
    pyqt = Formula["pyqt"]
    (testpath/"test.py").write <<~EOS
      import PyQt#{pyqt.version.major}.Qsci
      assert("QsciLexer" in dir(PyQt#{pyqt.version.major}.Qsci))
    EOS

    system python3, "test.py"
  end
end
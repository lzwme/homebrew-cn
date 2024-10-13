# Patches for Qt must be at the very least submitted to Qt's Gerrit codereview
# rather than their bug-report Jira. The latter is rarely reviewed by Qt.
class QtAT5 < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https:www.qt.io"
  # NOTE: Use *.diff for GitLabKDE patches to avoid their checksums changing.
  url "https:download.qt.ioofficial_releasesqt5.155.15.15singleqt-everywhere-opensource-src-5.15.15.tar.xz"
  mirror "https:mirrors.dotsrc.orgqtprojectarchiveqt5.155.15.15singleqt-everywhere-opensource-src-5.15.15.tar.xz"
  mirror "https:mirrors.ocf.berkeley.eduqtarchiveqt5.155.15.15singleqt-everywhere-opensource-src-5.15.15.tar.xz"
  sha256 "b423c30fe3ace7402e5301afbb464febfb3da33d6282a37a665be1e51502335e"
  license all_of: ["GFDL-1.3-only", "GPL-2.0-only", "GPL-3.0-only", "LGPL-2.1-only", "LGPL-3.0-only"]

  livecheck do
    url "https:download.qt.ioofficial_releasesqt5.15"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1afd63dc1e62e946c88c80e4192be654df4ac2fc11b82a0f71cd64c0f08fbfa"
    sha256 cellar: :any,                 arm64_sonoma:  "a0cfeeacfefeb3c3158b03fd3b35e04bdc72d627148bb00c4bc8f196b4d2c360"
    sha256 cellar: :any,                 arm64_ventura: "0acdf9040c7100ed5750d146191f51d055888f05cb25e57b6cd551d5c11017fc"
    sha256 cellar: :any,                 sonoma:        "57fb8ee5275428ee49452441bac8e0145c7cb2a6e3247a6f782359b56470df31"
    sha256 cellar: :any,                 ventura:       "37819927d329989f6b6e6b76e71ecce8f1731488a4b95356d98ff34d6a31fcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8ac60dbe7163744f27d127a8d5e47f6074ab21e6412a156d5a6cf5b71bf7c3"
  end

  keg_only :versioned_formula

  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on xcode: :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on macos: :sierra
  depends_on "md4c"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    depends_on "dbus"
    depends_on "double-conversion"
    depends_on "expat"
    depends_on "fontconfig"
    depends_on "harfbuzz"
    depends_on "icu4c@75"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxcomposite"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxml2"
    depends_on "libxrandr"
    depends_on "libxslt"
    depends_on "libxtst"
    depends_on "llvm"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nspr"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "sdl2"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
  end

  fails_with gcc: "5"

  resource "qtwebengine" do
    url "https:code.qt.ioqtqtwebengine.git",
        tag:      "v5.15.17-lts",
        revision: "17fd3176988586168bee8654008a097a5f23ec1d"

    # Use Arch Linux's patch for ICU 75 support
    patch do
      url "https:gitlab.archlinux.orgarchlinuxpackagingpackagesqt5-webengine-rawa6348f22ac66f1337f400497a5b36057810acf97qt5-webengine-icu-75.patch"
      sha256 "7cac28ba784d24b4abf6414079548ada165343af507ecd8e23cbe7e4f63ae52f"
      directory "src3rdparty"
    end

    # Use Arch Linux  Debian patches for Python 3.12 support
    patch do
      url "https:gitlab.archlinux.orgarchlinuxpackagingpackagesqt5-webengine-raw55a02804953a9035cdee7e6ff2e2dae0bf5c5feapython3.12-imp.patch"
      sha256 "1f4357708e985bb5aca61a7e5dc4c0c1285d2af00994bb49ff89ede78198e0d2"
      directory "src3rdpartychromium"
    end
    patch do
      url "https:gitlab.archlinux.orgarchlinuxpackagingpackagesqt5-webengine-raw6b0c0e76e0934db2f84be40cb5978cee47266e78python3.12-six.patch"
      sha256 "ac87ec55ee5cbcf2d520e1ea433d041c0bf754271a17f859edbb9976f192ce3f"
      directory "src3rdpartychromium"
    end
  end

  resource "html5lib" do
    url "https:files.pythonhosted.orgpackagesacb6b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "webencodings" do
    url "https:files.pythonhosted.orgpackages0b02ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  # Fix build with ICU 75
  patch do
    on_linux do
      url "https:invent.kde.orgqtqtqtlocation-mapboxgl-commit35d566724c48180c9a372c2ed50a253871a51574.diff"
      sha256 "9e61d46c0a8ae39903cbcbb228e384f2878a06e50448f3bba60ec65fe2890081"
      directory "qtlocationsrc3rdpartymapbox-gl-native"
    end
  end

  # Fix build with Xcode 14.3.
  # https:bugreports.qt.iobrowseQTBUG-112906
  patch do
    url "https:invent.kde.orgqtqtqtlocation-mapboxgl-commit5a07e1967dcc925d9def47accadae991436b9686.diff"
    sha256 "4f433bb009087d3fe51e3eec3eee6e33a51fde5c37712935b9ab96a7d7571e7d"
    directory "qtlocationsrc3rdpartymapbox-gl-native"
  end

  # Fix qmake with Xcode 15.
  # https:bugreports.qt.iobrowseQTBUG-117225
  # Likely can remove with 5.15.16.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches086e8cfqt5qt5-qmake-xcode15.patch"
    sha256 "802f29c2ccb846afa219f14876d9a1d67477ff90200befc2d0c5759c5081c613"
  end

  # Fix qtmultimedia build with Xcode 15
  # https:bugreports.qt.iobrowseQTBUG-113782
  # https:github.comhmaarrfkqt-main-feedstockblob0758b98854a3a3b9c99cded856176e96c9b8c0c5recipepatches0014-remove-usage-of-unary-operator.patch
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches3f509180qt5qt5-qtmultimedia-xcode15.patch"
    sha256 "887d6cb4fd115ce82323d17e69fafa606c51cef98c820b82309ab38288f21e08"
  end

  # Fix use of macOS 14 only memory_resource on macOS 13
  # The `_cpp_lib_memory_resource` feature test macro should be sufficient but a bug in the SDK means
  # the extra checks are required. This part of the patch will likely be fixed in a future SDK.
  # https:bugreports.qt.iobrowseQTBUG-114316
  # This can likely be removed in 5.15.16.
  patch :p0 do
    url "https:raw.githubusercontent.commacportsmacports-ports56a9af76a6bcecc3d12c3a65f2465c25e05f2559aquaqt5filespatch-qtbase-memory_resource.diff"
    sha256 "87967d685b08f06e91972a6d8c5e2e1ff672be9a2ba1d7d7084eba1413f641d5"
    directory "qtbase"
  end

  # CVE-2023-51714
  # Remove with Qt 5.15.17
  patch do
    url "https:download.qt.ioofficial_releasesqt5.150001-CVE-2023-51714-qtbase-5.15.diff"
    sha256 "2129058a5e24d98ee80a776c49a58c2671e06c338dffa7fc0154e82eef96c9d4"
    directory "qtbase"
  end
  patch do
    url "https:download.qt.ioofficial_releasesqt5.150002-CVE-2023-51714-qtbase-5.15.diff"
    sha256 "99d5d32527e767d6ab081ee090d92e0b11f27702619a4af8966b711db4f23e42"
    directory "qtbase"
  end

  def install
    # Install python dependencies for QtWebEngine
    venv = virtualenv_create(buildpath"venv", "python3.12")
    venv.pip_install resources.reject { |r| r.name == "qtwebengine" }
    ENV.prepend_path "PATH", venv.root"bin"

    rm_r(buildpath"qtwebengine")
    (buildpath"qtwebengine").install resource("qtwebengine")

    # FIXME: GN requires clang in clangBasePathbin
    inreplace "qtwebenginesrc3rdpartychromiumbuildtoolchainmacBUILD.gn",
              'rebase_path("$clang_base_pathbin", root_build_dir)', '""'

    args = %W[
      -verbose
      -prefix #{prefix}
      -release
      -opensource -confirm-license
      -nomake examples
      -nomake tests
      -pkg-config
      -dbus-runtime
      -proprietary-codecs
      -system-freetype
      -system-libjpeg
      -system-libmd4c
      -system-libpng
      -system-pcre
      -system-sqlite
      -system-zlib
      -webengine-python-version python3
    ]

    if OS.mac?
      args << "-no-rpath"
      args << "-no-assimp" if Hardware::CPU.arm?

      # Modify Assistant path as we manually move `*.app` bundles from `bin` to `libexec`.
      # This fixes invocation of Assistant via the Help menu of apps like Designer and
      # Linguist as they originally relied on Assistant.app being in `bin`.
      assistant_files = %w[
        qttoolssrcdesignersrcdesignerassistantclient.cpp
        qttoolssrclinguistlinguistmainwindow.cpp
      ]
      inreplace assistant_files, '"Assistant.appContentsMacOSAssistant"', '"Assistant"'
    else
      args << "-R#{lib}"
      # https:bugreports.qt.iobrowseQTBUG-71564
      args << "-no-avx2"
      args << "-no-avx512"
      args << "-no-sql-mysql"

      # Use additional system libraries on Linux.
      # Currently we have to use vendored ffmpeg because the chromium copy adds a symbol not
      # provided by the brewed version.
      # See here for an explanation of why upstream ffmpeg does not want to add this:
      # https:www.mail-archive.comffmpeg-devel@ffmpeg.orgmsg124998.html
      # On macOS chromium will always use bundled copies and the webengine_*
      # arguments are ignored.
      args += %w[
        -system-doubleconversion
        -system-harfbuzz
        -webengine-alsa
        -webengine-icu
        -webengine-kerberos
        -webengine-opus
        -webengine-pulseaudio
        -webengine-webp
      ]

      # Homebrew-specific workaround to ignore spurious linker warnings on Linux.
      inreplace "qtwebenginesrc3rdpartychromiumbuildconfigcompilerBUILD.gn",
                "fatal_linker_warnings = true",
                "fatal_linker_warnings = false"
    end

    # Work around Clang failure in bundled Boost and V8:
    # error: integer value -1 is outside the valid range of values [0, 3] for this enumeration type
    if DevelopmentTools.clang_build_version >= 1500
      args << "QMAKE_CXXFLAGS+=-Wno-enum-constexpr-conversion"
      inreplace "qtwebenginesrc3rdpartychromiumbuildconfigcompilerBUILD.gn",
                ^\s*"-Wno-thread-safety-attributes",$,
                "\\0 \"-Wno-enum-constexpr-conversion\","
    end

    system ".configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # Remove reference to shims directory
    inreplace prefix"mkspecsqmodule.pri",
              ^PKG_CONFIG_EXECUTABLE = .*$,
              "PKG_CONFIG_EXECUTABLE = #{Formula["pkg-config"].opt_bin}pkg-config"

    # Fix find_package call using QtWebEngine version to find other Qt5 modules.
    inreplace lib.glob("cmakeQt5WebEngine**Config.cmake"),
              " #{resource("qtwebengine").version} ", " #{version} "

    # Install a qtversion.xml to ease integration with QtCreator
    # As far as we can tell, there is no ability to make the Qt buildsystem
    # generate this and it's in the Qt source tarball at all.
    # Multiple people on StackOverflow have asked for this and it's a pain
    # to add Qt to QtCreator (the official IDE) without it.
    # Given Qt upstream seems extremely unlikely to accept this: let's ship our
    # own version.
    # If you read this and you can eliminate it or upstream it: please do!
    # More context in https:github.comHomebrewhomebrew-corepull124923
    qtversion_xml = share"qtcreatorQtProjectqtcreatorqtversion.xml"
    qtversion_xml.dirname.mkpath
    qtversion_xml.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE QtCreatorQtVersions>
      <qtcreator>
      <data>
        <variable>QtVersion.0<variable>
        <valuemap type="QVariantMap">
        <value type="int" key="Id">1<value>
        <value type="QString" key="Name">Qt %{Qt:Version} (#{opt_prefix})<value>
        <value type="QString" key="QMakePath">#{opt_bin}qmake<value>
        <value type="QString" key="QtVersion.Type">Qt4ProjectManager.QtVersion.Desktop<value>
        <value type="QString" key="autodetectionSource"><value>
        <value type="bool" key="isAutodetected">false<value>
        <valuemap>
      <data>
      <data>
        <variable>Version<variable>
        <value type="int">1<value>
      <data>
      <qtcreator>
    XML

    return unless OS.mac?

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f"Headers" => f.stem
    end

    # Move `*.app` bundles into `libexec` to expose them to `brew linkapps` and
    # because we don't like having them in `bin`.
    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexecapp.basename"ContentsMacOS"app.stem
    end
  end

  def caveats
    <<~EOS
      We agreed to the Qt open source license for you.
      If this is unacceptable you should uninstall.

      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{opt_prefix}
    EOS
  end

  test do
    (testpath"hello.pro").write <<~EOS
      QT       += core
      QT       -= gui
      TARGET    = hello
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE  = app
      SOURCES  += main.cpp
    EOS

    (testpath"main.cpp").write <<~EOS
      #include <QCoreApplication>
      #include <QDebug>

      int main(int argc, char *argv[])
      {
        QCoreApplication a(argc, argv);
        qDebug() << "Hello World!";
        return 0;
      }
    EOS

    # Work around "error: no member named 'signbit' in the global namespace"
    ENV.delete "CPATH"

    system bin"qmake", testpath"hello.pro"
    system "make"
    assert_predicate testpath"hello", :exist?
    assert_predicate testpath"main.o", :exist?
    system ".hello"
  end
end
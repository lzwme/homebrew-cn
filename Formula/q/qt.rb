class Qt < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform application and UI framework"
  homepage "https:www.qt.io"
  license all_of: [
    "BSD-3-Clause",
    "GFDL-1.3-no-invariants-only",
    "GPL-2.0-only",
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "LGPL-3.0-only",
  ]
  revision 2
  head "https:code.qt.ioqtqt5.git", branch: "dev"

  stable do
    url "https:download.qt.ioofficial_releasesqt6.66.6.2singleqt-everywhere-src-6.6.2.tar.xz"
    mirror "https:qt.mirror.constant.comarchiveqt6.66.6.2singleqt-everywhere-src-6.6.2.tar.xz"
    mirror "https:mirrors.ukfast.co.uksitesqt.ioarchiveqt6.66.6.2singleqt-everywhere-src-6.6.2.tar.xz"
    sha256 "3c1e42b3073ade1f7adbf06863c01e2c59521b7cc2349df2f74ecd7ebfcb922d"

    # Fix build with newer libc++.
    patch do
      url "https:github.comgoogleanglecommitc23029d2fe0a55a5b26cd8005f0bf74943ed3865.patch?full_index=1"
      sha256 "c6aa0f3237001e9ad9ed17dab671a2f402aa0060012a90349113f6cf9c0c95c1"
      directory "qtwebenginesrc3rdpartychromiumthird_partyangle"
    end
  end

  # The first-party website doesn't make version information readily available,
  # so we check the `head` repository tags instead.
  livecheck do
    url :head
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b38f05cfe4fa5c500aef53c3c5ea473a74bb1ede45d1780b2319a8a8c6705a88"
    sha256 cellar: :any,                 arm64_ventura:  "ab22a0f5ab48473cbab19430b6da428ce7f10cb53021a4c52d1d20bffd03c160"
    sha256 cellar: :any,                 arm64_monterey: "41296897961f7be62e2c3660b2bcad7d1bc42cf0bc1d4527b459795032ef5d26"
    sha256 cellar: :any,                 sonoma:         "97ae8277d876f50e1606dd8b5bb73e934848ba0e29e61bdc9374c3bab5bcc4ab"
    sha256 cellar: :any,                 ventura:        "f14630f2e75dfbfc5f2aaa704a174996290c3df08e31832cc3f310dbd1e904f6"
    sha256 cellar: :any,                 monterey:       "c422a0bd0ef0d4e3faffe44949adbfa1029769ab277ff802712ff9969a6e649c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75b1bde75ac96973f5c4a333fa0b0b2f1258a8f3bbd780e59334ba183ff4a2e1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # Python 3.12 needs newer Chromium without imp usage (maybe 118 or 120)
  depends_on "vulkan-headers" => [:build, :test]
  depends_on "vulkan-loader" => [:build, :test]
  depends_on xcode: :build

  depends_on "assimp"
  depends_on "brotli"
  depends_on "dbus"
  depends_on "double-conversion"
  depends_on "freetype"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "hunspell"
  depends_on "icu4c"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libb2"
  depends_on "libmng"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "md4c"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "llvm" => :test # Our test relies on `clang++` in `PATH`.

  uses_from_macos "cups"
  uses_from_macos "krb5"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk" => [:build, :test]
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "at-spi2-core"
    # TODO: depends_on "bluez"
    depends_on "ffmpeg@6"
    depends_on "fontconfig"
    depends_on "gstreamer"
    # TODO: depends_on "gypsy"
    depends_on "libdrm"
    depends_on "libevent"
    depends_on "libice"
    depends_on "libsm"
    depends_on "libvpx"
    depends_on "libxcomposite"
    depends_on "libxkbcommon"
    depends_on "libxkbfile"
    depends_on "libxrandr"
    depends_on "libxtst"
    depends_on "little-cms2"
    depends_on "mesa"
    depends_on "minizip"
    depends_on "nss"
    depends_on "opus"
    depends_on "pulseaudio"
    depends_on "sdl2"
    depends_on "snappy"
    depends_on "systemd"
    depends_on "wayland"
    depends_on "xcb-util"
    depends_on "xcb-util-image"
    depends_on "xcb-util-keysyms"
    depends_on "xcb-util-renderutil"
    depends_on "xcb-util-wm"
  end

  fails_with gcc: "5"

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

  def install
    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https:bugreports.qt.iobrowseQTBUG-113391
    ENV.runtime_cpu_detection

    python = "python3.11"
    # Install python dependencies for QtWebEngine
    venv_root = buildpath"venv"
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv_rootLanguage::Python.site_packages(python)

    # FIXME: GN requires clang in clangBasePathbin
    inreplace "qtwebenginesrc3rdpartychromiumbuildtoolchainappletoolchain.gni",
              'rebase_path("$clang_base_pathbin", root_build_dir)', '""'

    # FIXME: See https:bugreports.qt.iobrowseQTBUG-89559
    # and https:codereview.qt-project.orgcqtqtbase+327393
    # It is not friendly to Homebrew or macOS
    # because on macOS `tmp` -> `privatetmp`
    inreplace "qtwebenginesrc3rdpartygnsrcbasefilesfile_util_posix.cc",
              "FilePath(full_path)", "FilePath(input)"

    # Modify Assistant path as we manually move `*.app` bundles from `bin` to `libexec`.
    # This fixes invocation of Assistant via the Help menu of apps like Designer and
    # Linguist as they originally relied on Assistant.app being in `bin`.
    assistant_files = %w[
      qttoolssrcdesignersrcdesignerassistantclient.cpp
      qttoolssrclinguistlinguistmainwindow.cpp
    ]
    inreplace assistant_files, '"Assistant.appContentsMacOSAssistant"', '"Assistant"'

    # Allow generating unofficial pkg-config files for macOS to be used by other formulae.
    # Upstream currently does not provide them: https:bugreports.qt.iobrowseQTBUG-86080
    inreplace "qtbasecmakeQtPkgConfigHelpers.cmake", "(NOT UNIX OR QT_FEATURE_framework)", "(NOT UNIX)"

    config_args = %W[
      -release

      -prefix #{HOMEBREW_PREFIX}
      -extprefix #{prefix}

      -archdatadir shareqt
      -datadir shareqt
      -examplesdir shareqtexamples
      -testsdir shareqttests

      -no-feature-relocatable
      -system-harfbuzz
      -system-sqlite

      -no-sql-mysql
      -no-sql-odbc
      -no-sql-psql
    ]

    cmake_args = std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST") + %w[
      -DFEATURE_pkg_config=ON
      -DINSTALL_MKSPECSDIR=shareqtmkspecs
      -DQT_FEATURE_webengine_proprietary_codecs=ON
      -DQT_FEATURE_webengine_kerberos=ON
      -DQT_ALLOW_SYMLINK_IN_PATHS=ON
    ]

    if OS.mac?
      # Fix a regression in Qt 6.5.2 w.r.t. system libpng
      # https:bugreports.qt.iobrowseQTBUG-115357
      cmake_args << "-DQT_FEATURE_webengine_system_libpng=OFF"

      cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}.0"
      config_args << "-sysroot" << MacOS.sdk_path.to_s
      # NOTE: `chromium` should be built with the latest SDK because it uses
      # `___builtin_available` to ensure compatibility.
      config_args << "-skip" << "qtwebengine" if DevelopmentTools.clang_build_version <= 1200
    else
      # Explicitly specify QT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX so
      # that cmake does not think $HOMEBREW_PREFIXlib is the install prefix.
      cmake_args << "-DQT_BUILD_INTERNALS_RELOCATABLE_INSTALL_PREFIX=#{prefix}"

      # The vendored copy of libjpeg is also used instead of the brewed copy, because the build
      # fails due to a missing symbol otherwise.
      # On macOS chromium will always use bundled copies and the QT_FEATURE_webengine_system_*
      # arguments are ignored.
      cmake_args += %w[
        -DQT_FEATURE_webengine_system_alsa=ON
        -DQT_FEATURE_webengine_system_ffmpeg=ON
        -DQT_FEATURE_webengine_system_icu=ON
        -DQT_FEATURE_webengine_system_libevent=ON
        -DQT_FEATURE_webengine_system_libpng=ON
        -DQT_FEATURE_webengine_system_libxml=ON
        -DQT_FEATURE_webengine_system_libwebp=ON
        -DQT_FEATURE_webengine_system_minizip=ON
        -DQT_FEATURE_webengine_system_opus=ON
        -DQT_FEATURE_webengine_system_poppler=ON
        -DQT_FEATURE_webengine_system_pulseaudio=ON
        -DQT_FEATURE_webengine_system_zlib=ON
      ]

      # As of Qt 6.6.0, this feature appears to be mandatory for Linux.
      cmake_args << "-DQT_FEATURE_webengine_ozone_x11=ON"
    end

    system ".configure", *config_args, "--", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    inreplace lib"cmakeQt6qt.toolchain.cmake", "#{Superenv.shims_path}", ""

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
        <value type="QString" key="Name">Qt %{Qt:Version} (#{HOMEBREW_PREFIX})<value>
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
    # Tracking issues:
    # https:bugreports.qt.iobrowseQTBUG-86080
    # https:gitlab.kitware.comcmakecmake-merge_requests6363
    lib.glob("*.framework") do |f|
      # Some config scripts will only find Qt in a "Frameworks" folder
      frameworks.install_symlink f
      include.install_symlink f"Headers" => f.stem
    end

    bin.glob("*.app") do |app|
      libexec.install app
      bin.write_exec_script libexecapp.basename"ContentsMacOS"app.stem
    end

    # Modify unofficial pkg-config files to fix up paths and use frameworks.
    # Also move them to `libexec` as they are not guaranteed to work for users,
    # i.e. there is no upstream or Homebrew support.
    lib.glob("pkgconfig*.pc") do |pc|
      inreplace pc do |s|
        s.gsub! " -L${libdir}", " -F${libdir}", false
        s.gsub! " -lQt6", " -framework Qt", false
        s.gsub! " -Ilib", " -I${libdir}", false
      end
      (libexec"libpkgconfig").install pc
    end
  end

  def caveats
    <<~EOS
      You can add Homebrew's Qt to QtCreator's "Qt Versions" in:
        Preferences > Qt Versions > Link with Qt...
      pressing "Choose..." and selecting as the Qt installation path:
        #{HOMEBREW_PREFIX}
    EOS
  end

  test do
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core Gui Widgets Sql Concurrent
        3DCore Svg Quick3D Network NetworkAuth WebEngineCore REQUIRED)

      add_executable(test
          main.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core Qt6::Widgets
        Qt6::Sql Qt6::Concurrent Qt6::3DCore Qt6::Svg Qt6::Quick3D
        Qt6::Network Qt6::NetworkAuth Qt6::Gui Qt6::WebEngineCore
      )
    EOS

    (testpath"test.pro").write <<~EOS
      QT       += core svg 3dcore network networkauth quick3d \
        sql gui widgets webenginecore
      TARGET = test
      CONFIG   += console
      CONFIG   -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
      INCLUDEPATH += #{Formula["vulkan-headers"].opt_include}
    EOS

    (testpath"main.cpp").write <<~EOS
      #undef QT_NO_DEBUG
      #include <QCoreApplication>
      #include <Qt3DCore>
      #include <QtQuick3D>
      #include <QImageReader>
      #include <QtNetworkAuth>
      #include <QtSql>
      #include <QtSvg>
      #include <QDebug>
      #include <QVulkanInstance>
      #include <QtWebEngineCore>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        QCoreApplication app(argc, argv);
        QSvgGenerator generator;
        auto *handler = new QOAuthHttpServerReplyHandler();
        delete handler; handler = nullptr;
        auto *root = new Qt3DCore::QEntity();
        delete root; root = nullptr;
        Q_ASSERT(QSqlDatabase::isDriverAvailable("QSQLITE"));
        const auto &list = QImageReader::supportedImageFormats();
        QVulkanInstance inst;
         See https:github.comactionsrunner-imagesissues1779
         if (!inst.create())
           qFatal("Failed to create Vulkan instance: %d", inst.errorCode());
        for(const char* fmt:{"bmp", "cur", "gif",
          #ifdef __APPLE__
            "heic", "heif",
          #endif
          "icns", "ico", "jp2", "jpeg", "jpg", "pbm", "pgm", "png",
          "ppm", "svg", "svgz", "tga", "tif", "tiff", "wbmp", "webp",
          "xbm", "xpm"}) {
          Q_ASSERT(list.contains(fmt));
        }
        return 0;
      }
    EOS

    ENV["QT_VULKAN_LIB"] = Formula["vulkan-loader"].opt_lib(shared_library "libvulkan")
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", testpath
    system "make"
    system ".test"

    ENV.delete "CPATH" if OS.mac? && MacOS.version > :mojave
    system bin"qmake", testpath"test.pro"
    system "make"
    system ".test"
  end
end
class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https:www.wxwidgets.org"
  url "https:github.comwxWidgetswxWidgetsreleasesdownloadv3.2.5wxWidgets-3.2.5.tar.bz2"
  sha256 "0ad86a3ad3e2e519b6a705248fc9226e3a09bbf069c6c692a02acf7c2d1c6b51"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https:github.comwxWidgetswxWidgets.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "341a98e63601c8d559ded4619756e89aa28fd3758aea7bfd90f418eac53ab997"
    sha256 cellar: :any,                 arm64_sonoma:   "f60cb6453e7be47f08e6ddefaaa33fc9ccf6194388691030094bb62bbd630de8"
    sha256 cellar: :any,                 arm64_ventura:  "81fb3169db2d7e911a67893dbf3598959d363e1e7e0eb60f5351d7547e1eb195"
    sha256 cellar: :any,                 arm64_monterey: "1465a4d6417620de549a39ed7cdc7158915d09be7b7e840c9184a0742cfe7e94"
    sha256 cellar: :any,                 sonoma:         "95c8ec20d0c3497214a8e6117289d1bd9a96af7e2b1412c717b6b616c759eedc"
    sha256 cellar: :any,                 ventura:        "3e4fb827c277852a4ad4bb7cd11c6bfa6994b89fdedb9e38097c1b1f46801ff3"
    sha256 cellar: :any,                 monterey:       "169b1826552414f2fd053d74269d516a3b70eef6413d8d53e6a58322822116f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a89701497f550d84946e5109a2eec6ad5b06d3327311473ba2c1d32d8931d980"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    # Remove all bundled libraries excluding `nanosvg` which isn't available as formula
    %w[catch pcre].each { |l| rm_r(buildpath"3rdparty"l) }
    %w[expat jpeg png tiff zlib].each { |l| rm_r(buildpath"src"l) }

    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-zlib",
      "--disable-dependency-tracking",
      "--disable-tests",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"

      # Work around deprecated Carbon API, see
      # https:github.comwxWidgetswxWidgetsissues24724
      inreplace "srcosxcarbondcscreen.cpp", "#if !wxOSX_USE_IPHONE", "#if 0" if MacOS.version >= :sequoia
    end

    system ".configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace bin"wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink bin"wx-config" => "wx-config-#{version.major_minor}"
    (share"wx"version.major_minor).install share"aclocal", share"bakefile"
  end

  test do
    system bin"wx-config", "--libs"
  end
end
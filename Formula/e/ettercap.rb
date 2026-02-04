class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://ghfast.top/https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "1674c235b16b2048888b85a697697eb0c4e742f875fdaaef7acacc152568ad06"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d866253edf99e32aabd71af32cdb93a04dab5e338df81c29dde60a878b2686c4"
    sha256 arm64_sequoia: "6a9ecd815259623b2fda2ad8ceb8a5b24f95358d985d44de34fc4c55bd03c988"
    sha256 arm64_sonoma:  "4c258ce9751edc76d653f25b962cc8f76547f3633d3a648780603feb6f086288"
    sha256 sonoma:        "98b79bd173e14e6a247c8c999b2420934868c1e1e93cb675b859d0ca8d0b11b2"
    sha256 arm64_linux:   "0fea091086e5e9b3b2de29839a96cdc9751569837145691697c381bc037bfe1d"
    sha256 x86_64_linux:  "f9c93080e72d8a6eb989b37fffb75b49b6325e06c8bc0682af5c22f56226a3c4"
  end

  depends_on "cmake" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "freetype"
    depends_on "pango"
  end

  def install
    args = %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"ettercap")}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DGTK3_GLIBCONFIG_INCLUDE_DIR=#{Formula["glib"].opt_lib}/glib-2.0/include
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    if OS.linux?
      # Fix build error on wdg_file.c: fatal error: menu.h: No such file or directory
      ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw"
      args << "-DPOLKIT_DIR=#{share}/polkit-1/actions/"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
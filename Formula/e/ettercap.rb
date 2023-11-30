class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://ghproxy.com/https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.3.1.tar.gz"
    sha256 "d0c3ef88dfc284b61d3d5b64d946c1160fd04276b448519c1ae4438a9cdffaf3"

    depends_on "geoip"
    depends_on "pcre"

    # Fix build for curl 8+
    # https://github.com/Ettercap/ettercap/pull/1221
    patch do
      url "https://github.com/Ettercap/ettercap/commit/40534662043b7d831d1f6c70448afa9d374a9b63.patch?full_index=1"
      sha256 "ac9edbd2f5d2e809835f8b111a7f20000ffab0efca2d6f17f4b199bb325009b1"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "b7dce4ffbc4a8955cf236af6dfcf9736d4dc56021af45095afc5b4e748970481"
    sha256 arm64_ventura:  "5d826eeca55c11592a7b2af06078b5a37c860917858bd5f93fe08d2e87945664"
    sha256 arm64_monterey: "0b07ec219bb442ae8e4f86a51c78597f735dbdde70c5255e45ff215b796c991b"
    sha256 sonoma:         "884ff9c499236bb99752d79ab82c2b7323f1717eaab4ecc0c8198ce8fa38cd69"
    sha256 ventura:        "3114d8fb7118a356488eb79defb67711cc1a85f0fcd012f4f56f39158dec6c57"
    sha256 monterey:       "6d35a760e27011d72de19de5e54cfe1592e8ec5bfce4500fc1a41be83a3ed2b5"
    sha256 x86_64_linux:   "4af2b253084a937c8e67366c70a75e838002659941ea31ba88b7c8a4c2026aeb"
  end

  head do
    url "https://github.com/Ettercap/ettercap.git", branch: "master"

    depends_on "libmaxminddb"
    depends_on "pcre2"
  end

  depends_on "cmake" => :build
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    # Use ninja to work around build failure with make:
    # .../tapi stubify -isysroot ... -o libettercap-ui.0.8.3.1.tbd libettercap-ui.0.8.3.1.dylib
    # error: no such file or directory: 'libettercap-ui.0.8.3.1.dylib'
    depends_on "ninja" => :build
  end

  def install
    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

    args = %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
    else
      args << "-GNinja"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
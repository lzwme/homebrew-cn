class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://ghproxy.com/https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20231021.tar.gz"
  sha256 "2e7179885d167dffd894a458fdea23f8aba7f199ddabd7928bfa19427091e3d5"
  license "MIT"
  version_scheme 1
  head "https://github.com/openresty/luajit2.git", branch: "v2.1-agentzh"

  # The latest LuaJIT release is unstable (2.1.0-beta3, from 2017-05-01) and
  # OpenResty is making releases using the latest LuaJIT Git commits. With this
  # in mind, the regex below is very permissive and will match any tags
  # starting with a numeric version, ensuring that we match unstable versions.
  # We should consider restricting the regex to stable versions if it ever
  # becomes feasible in the future.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+[^{}]*)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d3259747de2de8de67aeaf4ed5a649c92a7815d74942bb031b91bb96424c70a"
    sha256 cellar: :any,                 arm64_ventura:  "4b23ad20c51188d602245fb834cf5ffaf4b7b88d91dd0c537617c9d470bf5ec9"
    sha256 cellar: :any,                 arm64_monterey: "6d855300e9944696e28007a156d16b73520787aee542b6c9c27623b765b16e0c"
    sha256 cellar: :any,                 sonoma:         "ff677e664e3b2131c998426e24d1e0eaf7d40d7b74ec7328d15705cab038d965"
    sha256 cellar: :any,                 ventura:        "247ca58bd4d917dd7f663366ecc2ec87147c5ff9c6749c094bb186faa97adc34"
    sha256 cellar: :any,                 monterey:       "31eca496f129ddbcb1a7e2aa5f199ed9b4f5a4b3884b03393079e9ec7f5e0d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925ef41a6b80894ac0f9fe9cfd5c5db427fa90db0510c1edc859c6d3bd1dc8ca"
  end

  keg_only "it conflicts with the LuaJIT formula"

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    args = %W[
      PREFIX=#{prefix}
      XCFLAGS=-DLUAJIT_ENABLE_GC64
    ]

    system "make", "amalg", *args
    system "make", "install", *args

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/"libluajit-5.1.dylib" => "libluajit.dylib"
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
    end

    # Having an empty Lua dir in lib/share can mess with other Homebrew Luas.
    %W[#{lib}/lua #{share}/lua].each { |d| rm_rf d }
  end

  test do
    system "#{bin}/luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
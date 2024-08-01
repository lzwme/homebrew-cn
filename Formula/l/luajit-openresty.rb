class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https:github.comopenrestyluajit2"
  url "https:github.comopenrestyluajit2archiverefstagsv2.1-20240626.tar.gz"
  sha256 "1e53822a1105df216b9657ccb0293a152ac5afd875abc848453bfa353ca8181b"
  license "MIT"
  version_scheme 1
  head "https:github.comopenrestyluajit2.git", branch: "v2.1-agentzh"

  # The latest LuaJIT release is unstable (2.1.0-beta3, from 2017-05-01) and
  # OpenResty is making releases using the latest LuaJIT Git commits. With this
  # in mind, the regex below is very permissive and will match any tags
  # starting with a numeric version, ensuring that we match unstable versions.
  # We should consider restricting the regex to stable versions if it ever
  # becomes feasible in the future.
  livecheck do
    url :stable
    regex(^v?(\d+(?:[.-]\d+)+[^{}]*)i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e70889c9a7bfa8b61a8474a44120a4a2544f86d6230fe1b3aa497a6c00b692f6"
    sha256 cellar: :any,                 arm64_ventura:  "40bf44b1f344c4e5df2846c87818116370ea550d92399f3c3a88bba67ccb4b85"
    sha256 cellar: :any,                 arm64_monterey: "ec862c0fe1202359d8b5ec4b7101dabbb186e6bf6a37b8d415ded6b115a34c9c"
    sha256 cellar: :any,                 sonoma:         "871a89f73556a275e4ade97e5ef38c7edd2c2456916add7e7fac9371557788d5"
    sha256 cellar: :any,                 ventura:        "b7f28e97ddfa79551ec1d4a797a6bd5b312c3f72d05a011d342d6da6a3f7231f"
    sha256 cellar: :any,                 monterey:       "671bee51f1c87168c30b95e690f73988eb9709555fb90811727eb8145b9c87f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d87a470ae02c6b2c445c36e38716145506edc21dd6837f6f482d63f2647c40"
  end

  keg_only "it conflicts with the LuaJIT formula"

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "srcMakefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.change_make_var! "CCOPT_x86", ""
    end

    # Per https:luajit.orginstall.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    args = %W[
      PREFIX=#{prefix}
      XCFLAGS=-DLUAJIT_ENABLE_GC64
    ]

    system "make", "amalg", *args
    system "make", "install", *args

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https:github.comHomebrewhomebrewissues45854.
    lib.install_symlink lib"libluajit-5.1.dylib" => "libluajit.dylib"
    lib.install_symlink lib"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib"pkgconfigluajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}sharelua${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}sharelua${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}${multilib}lua${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}${multilib}lua${abiver}"
    end

    # Having an empty Lua dir in libshare can mess with other Homebrew Luas.
    %W[#{lib}lua #{share}lua].each { |d| rm_r(d) }
  end

  test do
    system "#{bin}luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
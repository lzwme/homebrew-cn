class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https:github.comopenrestyluajit2"
  url "https:github.comopenrestyluajit2archiverefstagsv2.1-20241104.tar.gz"
  sha256 "197a5eb626bc9e0c19dcb025a190735ca1e23890606204bd9ef4c9828d5c4d4a"
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
    sha256 cellar: :any,                 arm64_sequoia: "2e3bee2f3622c951ec6980aa98b5f1b75fd01ef3f44133b7a55953120d925810"
    sha256 cellar: :any,                 arm64_sonoma:  "842974aa185d0939d37e6216fc67eee44cfe00dcda80db4668d50d4b91a43936"
    sha256 cellar: :any,                 arm64_ventura: "a5ae1b47f5f82287101904faf1b850a271500045d2562de52de874b9a79ca31d"
    sha256 cellar: :any,                 sonoma:        "abbe19f8b818d75439f305ccd23d0a0fb1308a7a9d2c2f4ad1f8ea1d62b9395a"
    sha256 cellar: :any,                 ventura:       "8191206b7b53b6678be0f075e2fd98e8db316469b674c95bb106e3eb9f540d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b491702bf453e23917adf40bf2be3e29733af5146f89ad240030a9a8714ee59c"
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

    # Fix for clang >= 16, see https:github.comLuaJITLuaJITissues1266
    ENV.append "LDFLAGS", "-Wl,-no_deduplicate" if DevelopmentTools.clang_build_version >= 1600

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
    system bin"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
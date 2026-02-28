class LuajitOpenresty < Formula
  desc "OpenResty's Branch of LuaJIT 2"
  homepage "https://github.com/openresty/luajit2"
  url "https://ghfast.top/https://github.com/openresty/luajit2/archive/refs/tags/v2.1-20260227.tar.gz"
  sha256 "5a0df315f88fea733f1f4296d119f0816eb395d1da39d49b4b1758d44d7dee31"
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
    sha256 cellar: :any,                 arm64_tahoe:   "d065f4d6021bc99868ae55fb1cbd5404cbad74b8451704373f7e5117e65db79e"
    sha256 cellar: :any,                 arm64_sequoia: "e6070190d65911adcd40349b1c0fe673d4367e0d23169072cb26ff74eaa4b47b"
    sha256 cellar: :any,                 arm64_sonoma:  "e060ea41290245af6bdafafc3beb9412743b94740a9f868b3e961435ab7b1be3"
    sha256 cellar: :any,                 sonoma:        "5b0c9af8c02e9ff223931e5cd524324d633af3fd8a568866137e018ca76dc8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8040c7e8723746596a099290989e88408776a1efe00a2de1b381e0e315a7b615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca79f29b1a4d166d22ced27771b4c84debd6a22c4040047241411bc0b4a4e538"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    # Fix for clang >= 16, see https://github.com/LuaJIT/LuaJIT/issues/1266
    ENV.append "LDFLAGS", "-Wl,-no_deduplicate" if DevelopmentTools.clang_build_version >= 1600

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
    %W[#{lib}/lua #{share}/lua].each { |d| rm_r(d) }
  end

  test do
    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS
  end
end
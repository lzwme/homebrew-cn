# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https:github.comHomebrewhomebrew-corepull99580
# TODO: Add an audit in `brew` for this. https:github.comHomebrewhomebrew-corepull104765
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https:luajit.orgluajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  # Get the latest commit with:
  #   `git ls-remote --heads https:github.comLuaJITLuaJIT.git v2.1`
  # This is a rolling release model so take care not to ignore CI failures that may be regressions.
  url "https:github.comLuaJITLuaJITarchivec68711cc872e6626dc9e653e94df7bf21691d38e.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1724232689"
  sha256 "2cb49fa7d63469c11fd8952d9268e35c3ec36e64f115de2651196ef55e36dfd4"
  license "MIT"
  head "https:luajit.orggitluajit.git", branch: "v2.1"

  livecheck do
    url "https:api.github.comreposLuaJITLuaJITbranchesv2.1"
    strategy :json do |json|
      date = json.dig("commit", "commit", "author", "date")
      "2.1.#{DateTime.parse(date).strftime("%s")}"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b43d934a6adf5a844e85c547c6a2a946fd1b8c200ce039d76f1f1abd5ca55d6"
    sha256 cellar: :any,                 arm64_ventura:  "89d8873bce50d273fa34c52661772d90a2cfa26845d6a21324847b53aa48e621"
    sha256 cellar: :any,                 arm64_monterey: "aa173371ef80084ef253f4d7b8a6700410b4055fec436cd669c800aac046255a"
    sha256 cellar: :any,                 sonoma:         "df2894987282a1342530b865c25c0317b0e1bdac6b016b88761ea68ac68844f6"
    sha256 cellar: :any,                 ventura:        "4ffc8495a9190e9dc9eea66c53a7cf862cc05afa92af4403fe9d889774918e2d"
    sha256 cellar: :any,                 monterey:       "850efb226cecd74221b046cad9f5453f1152a6711b20f2f088e9088ed965d488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57479024900c1ff635c3a70746f948b670b31fa8c40ab3e82085f0ba0c8ac62"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "srcMakefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(-march=\w+\s?, "")
    end

    # Per https:luajit.orginstall.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    # Help the FFI module find Homebrew-installed libraries.
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: HOMEBREW_PREFIX"lib")}" if HOMEBREW_PREFIX.to_s != "usrlocal"

    # Pass `Q= E=@:` to build verbosely.
    verbose_args = %w[Q= E=@:]

    # Build with PREFIX=$HOMEBREW_PREFIX so that luajit can find modules outside its own keg.
    # This allows us to avoid having to set `LUA_PATH` and `LUA_CPATH` for non-vendored modules.
    system "make", "amalg", "PREFIX=#{HOMEBREW_PREFIX}", *verbose_args
    system "make", "install", "PREFIX=#{prefix}", *verbose_args
    doc.install (buildpath"doc").children

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https:github.comHomebrewhomebrewissues45854.
    lib.install_symlink libshared_library("libluajit-5.1") => shared_library("libluajit")
    lib.install_symlink lib"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib"pkgconfigluajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}sharelua${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}sharelua${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}${multilib}lua${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}${multilib}lua${abiver}"
    end
  end

  test do
    assert_includes shell_output("#{bin}luajit -v"), " #{version} "

    system bin"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS

    # Check that LuaJIT can find its own `jit.*` modules
    touch "empty.lua"
    system bin"luajit", "-b", "-o", "osx", "empty.lua", "empty.o"
    assert_predicate testpath"empty.o", :exist?

    # Check that we're not affected by LuaJITLuaJITissues865.
    require "macho"
    machobj = MachO.open("empty.o")
    # always generate 64 bit non-FAT Mach-O object files
    # per https:github.comLuaJITLuaJITcommit7110b935672489afd6ba3eef3e5139d2f3bd05b6
    assert_kind_of MachO::MachOFile, machobj
    assert_predicate machobj, :object?
    assert_equal Hardware::CPU.arch, machobj.cputype
  end
end
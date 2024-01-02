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
  url "https:github.comLuaJITLuaJITarchivec525bcb9024510cad9e170e12b6209aedb330f83.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1703358377"
  sha256 "eb20affc70a9e97a8a0e1e0b10456f220fca7637a198e4a937b5fc827dd1ef95"
  license "MIT"
  head "https:luajit.orggitluajit.git", branch: "v2.1"

  livecheck do
    url "https:github.comLuaJITLuaJITcommitsv2.1"
    regex(<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "2.1.#{DateTime.parse(match[0]).strftime("%s")}" }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a32867b316e92b56c8599f18850c840741a3f4ce50643e05fed42931ff0704b"
    sha256 cellar: :any,                 arm64_ventura:  "1bbe3bc2ff08b75ff17b91fd3898f2f46e73222d7eb0b51de40cb4fc03141987"
    sha256 cellar: :any,                 arm64_monterey: "e093bd65496957e4689f058412574b1a9babf896773126d0478ea72dd6b7bae8"
    sha256 cellar: :any,                 sonoma:         "2f4d98d4898f9aa39853e39f149026d76a4377ad8381260ca7f7898c620fe133"
    sha256 cellar: :any,                 ventura:        "3ea6d00c0e65f1099d0cb2ceadb31e41a064405b8e8a589a4267292253813a2c"
    sha256 cellar: :any,                 monterey:       "786ffed5b23502f661fce82e039a4c36f3d067a2402521210db1d3f3c0ce2f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f8b0b7bc94f680802e161d05dbadbe7bd5b5440701638e77cbd595e0ebcfe9"
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
    system bin"luajit", "-b", "-o", "osx", "-a", "arm64", "empty.lua", "empty.o"
    assert_predicate testpath"empty.o", :exist?

    # Check that we're not affected by LuaJITLuaJITissues865.
    require "macho"
    machobj = MachO.open("empty.o")
    assert_kind_of MachO::FatFile, machobj
    assert_predicate machobj, :object?

    cputypes = machobj.machos.map(&:cputype)
    assert_includes cputypes, :arm64
    assert_includes cputypes, :x86_64
    assert_equal 2, cputypes.length
  end
end
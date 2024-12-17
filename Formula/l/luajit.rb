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
  url "https:github.comLuaJITLuaJITarchivef73e649a954b599fc184726c376476e7a5c439ca.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1734355927"
  sha256 "bc992b3ae0a8f5f0ebbf141626b7c99fac794c94ec6896d973582525c7ef868d"
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
    sha256 cellar: :any,                 arm64_sequoia: "03d962dafcf1b727cb8e8ebe3b7e83967717c1505df55a89cf13d7298aa8f9da"
    sha256 cellar: :any,                 arm64_sonoma:  "6ed5ad658fd4107af5271ac9b6be6f3dc7eb676d3ce275c47fad83b6d0c1c386"
    sha256 cellar: :any,                 arm64_ventura: "0dcb50b5ed4180533bf0d42b68e7fd346ce9e4fdcb1a6e568a4c4e9dab88d877"
    sha256 cellar: :any,                 sonoma:        "98e5e0251159863f4e32d5931ca1e6cd63a959aa58b825b49bca7c54656a2067"
    sha256 cellar: :any,                 ventura:       "1816ef4f41fab4d5fac8464a90fd127106996576b554e555376b40855aa9529e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6836fca40ab80c6c9de9d5600d5391fc25240967fae4151d37fc7115a38fb9c4"
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
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: HOMEBREW_PREFIX"lib")}"

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
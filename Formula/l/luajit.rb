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
  url "https:github.comLuaJITLuaJITarchivee0a7ea8a924d8137e6950b97c3e36f17264f6c79.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1744014795"
  sha256 "7e31b2151dc66d627d232d7e07acb89b9c5f2742d7e2dd74542fa41ccaf4b413"
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
    sha256 cellar: :any,                 arm64_sequoia: "d444e412255f569449990cf06196f5c4f215c264bab2c8ce91d4e323320c94e2"
    sha256 cellar: :any,                 arm64_sonoma:  "1b360ed487719f23ea6d8a7c2bfd63e0b5050137f82a2d372ae8048fc13ece23"
    sha256 cellar: :any,                 arm64_ventura: "1c92f0f0df3eaeaa01d31c88c407db22b3691e2647c66d1b2efad33d31146845"
    sha256 cellar: :any,                 sonoma:        "a4e30b4b6f96ee2910ce42a7abb8bb048163d91ed45c1a03bc4667304730d544"
    sha256 cellar: :any,                 ventura:       "7fb03a057ce66ee8df34be0de100afd830a5688fac127cf5c5e65d65784a27ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef8c90c0dce5b7bef06a10682da821706eb8cd6793659bdc87fcb9461606f035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4ee37701d4c1b8b918c7852bd4cdffa9aee01e4102389168324f64d297dbce"
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
    assert_path_exists testpath"empty.o"

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
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
  url "https:github.comLuaJITLuaJITarchive84cb21ffaf648b472ff3884556e2c413e8abe179.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1741571767"
  sha256 "30c1118b8eced22a6f5be5630458e4cf10a0f429adcaa019e356ddd05456bb81"
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
    sha256 cellar: :any,                 arm64_sequoia: "6340186cd70b6b2ea7eac1b88d7c7f4e27053d488617492b28f3e97c814bcdde"
    sha256 cellar: :any,                 arm64_sonoma:  "1887ba608a8553cb6722e0316d0e922e40f1f0e0b36e75cbeac39e76d54b1895"
    sha256 cellar: :any,                 arm64_ventura: "ecb08222c6f920179eb8cc2da7d7ae38f76e210a03cb22495cbd0b2d115d9dd4"
    sha256 cellar: :any,                 sonoma:        "4e9dafeffb97ee653c7fd59b76b6dca3f4a9e79a8b6b89b7955f5d23ba5fa80d"
    sha256 cellar: :any,                 ventura:       "7d0f019b7db7c821fd9cba7e05ae088b4013f2629aabe6f89e09dd435919ec75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e398471f2f904f14d6d38989b10242560c4a26557f08e156e16ba92a1200473f"
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
# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
# TODO: Add an audit in `brew` for this. https://github.com/Homebrew/homebrew-core/pull/104765
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  # Get the latest commit with:
  #   `git ls-remote --heads https://github.com/LuaJIT/LuaJIT.git v2.1`
  # This is a rolling release model so take care not to ignore CI failures that may be regressions.
  url "https://ghproxy.com/https://github.com/LuaJIT/LuaJIT/archive/e826d0c101d750fac8334d71e221c50d8dbe236c.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1697887905"
  sha256 "59b00e97cae773ff27a8cca92b560e0e126c79d2b7c4c47acee4ddd387c9c2ad"
  license "MIT"
  head "https://luajit.org/git/luajit.git", branch: "v2.1"

  livecheck do
    url "https://github.com/LuaJIT/LuaJIT/commits/v2.1"
    regex(/<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]/im)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "2.1.#{DateTime.parse(match[0]).strftime("%s")}" }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "729d5bf621422f926030c71deb3c388d8aa275175525b80174a03017f1ece9c1"
    sha256 cellar: :any,                 arm64_ventura:  "b832311e41c67dfb6e184f1f40166fa63233f2f474eeda7dc9fb7ead4b625faa"
    sha256 cellar: :any,                 arm64_monterey: "077cc2d5eeec868a2442c2e37d0b3910dafcfff9dcd3af891d6eb2aafdae2662"
    sha256 cellar: :any,                 sonoma:         "d1c00b3ae1795d7bf919c9554a55cf18a4b7bfa3af93f0c58d51489dc59fa3a3"
    sha256 cellar: :any,                 ventura:        "ebec6a9ee1822ee4ae2decd1069c6e81892b8f22ee8866a273f059abec7ea170"
    sha256 cellar: :any,                 monterey:       "79565781ff2844f3faead615722dae05e368f2265efbe7e66a8c5bb91cfd9ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1282a8bdedbdcc1cd831f784fb0bd588fcc4ebd3487a25a49540bdd1d006769a"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(/-march=\w+\s?/, "")
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    # Help the FFI module find Homebrew-installed libraries.
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: HOMEBREW_PREFIX/"lib")}" if HOMEBREW_PREFIX.to_s != "/usr/local"

    # Pass `Q= E=@:` to build verbosely.
    verbose_args = %w[Q= E=@:]

    # Build with PREFIX=$HOMEBREW_PREFIX so that luajit can find modules outside its own keg.
    # This allows us to avoid having to set `LUA_PATH` and `LUA_CPATH` for non-vendored modules.
    system "make", "amalg", "PREFIX=#{HOMEBREW_PREFIX}", *verbose_args
    system "make", "install", "PREFIX=#{prefix}", *verbose_args
    doc.install (buildpath/"doc").children

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/shared_library("libluajit-5.1") => shared_library("libluajit")
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
    end
  end

  test do
    assert_includes shell_output("#{bin}/luajit -v"), " #{version} "

    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS

    # Check that LuaJIT can find its own `jit.*` modules
    touch "empty.lua"
    system bin/"luajit", "-b", "-o", "osx", "-a", "arm64", "empty.lua", "empty.o"
    assert_predicate testpath/"empty.o", :exist?

    # Check that we're not affected by LuaJIT/LuaJIT/issues/865.
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
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
  url "https://ghproxy.com/https://github.com/LuaJIT/LuaJIT/archive/0cc5fdfbc0810073485150eb184dc358dab507d9.tar.gz"
  # Use the version scheme `2.1.0-beta3-yyyymmdd.x` where `yyyymmdd` is the date of the
  # latest commit at the time of updating, and `x` is the number of commits on that date.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.0-beta3-20230708.6"
  sha256 "a4f89240dd22738ff72c28360da5c69d3fcef2dcbeae58880c050fd78264d9f3"
  license "MIT"
  head "https://luajit.org/git/luajit-2.0.git", branch: "v2.1"

  livecheck do
    url "https://github.com/LuaJIT/LuaJIT/commits/v2.1"
    regex(/<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]/im)
    strategy :page_match do |page, regex|
      newest_date = nil
      commit_count = 0
      page.scan(regex).map do |match|
        date = Date.parse(match[0])
        newest_date ||= date
        break if date != newest_date

        commit_count += 1
      end
      next if newest_date.blank? || commit_count.zero?

      # The main LuaJIT version is rarely updated, so we recycle it from the
      # `version` to avoid having to fetch another page.
      version.to_s.sub(/\d+\.\d+$/, "#{newest_date.strftime("%Y%m%d")}.#{commit_count}")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3b157d51094d23502b587a552af3290f2954178a002727b083d215402718c65"
    sha256 cellar: :any,                 arm64_monterey: "0eaefd7fbdba59d515e769097a2afff54833c3459bddbb79a81f9537de0705b8"
    sha256 cellar: :any,                 arm64_big_sur:  "158ebde320658eee4fa66b08b66441cd9159b4924e4630ab27f236a1124de8d8"
    sha256 cellar: :any,                 ventura:        "47fc0236c82068e6277372177e458702ad717f3816d218ff59519d5af8882fb4"
    sha256 cellar: :any,                 monterey:       "348d233b29745037513e7acb2ae91e0639a26164ee5047813a84b8a6ffa00383"
    sha256 cellar: :any,                 big_sur:        "7130a0023ef28a7834053ad73fd472046dc7472c813ec2eda570211c106d50dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5cbc09abb082d9d396b8120e5a386c5dbd3ba7d6e6003ec1228c51dc74f0181"
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

    # We need `stable.version` here to avoid breaking symlink generation for HEAD.
    upstream_version = stable.version.to_s.sub(/-\d+\.\d+$/, "")
    # v2.1 branch doesn't install symlink for luajit.
    # This breaks tools like `luarocks` that require the `luajit` bin to be present.
    bin.install_symlink "luajit-#{upstream_version}" => "luajit"

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
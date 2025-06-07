class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https:luarocks.org"
  url "https:luarocks.orgreleasesluarocks-3.12.0.tar.gz"
  sha256 "3d4c8acddf9b975e77da68cbf748d5baf483d0b6e9d703a844882db25dd61cdf"
  license "MIT"
  head "https:github.comluarocksluarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78cf2c9f0b7d5235102f6bccfa9c2aa43857cff0b7a6f5d50225c45677b4cd98"
  end

  depends_on "luajit" => :test
  depends_on "lua"

  uses_from_macos "unzip"

  def install
    # Fix the lua config file missing issue for luarocks-admin build
    ENV.deparallelize

    system ".configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--rocks-tree=#{HOMEBREW_PREFIX}"
    system "make", "install"
    generate_completions_from_executable(bin"luarocks", "completion")

    # Make bottles uniform to make an `:all` bottle
    luaversion = Formula["lua"].version.major_minor
    inreplace_files = %w[
      cmdconfig
      cmdwhich
      corecfg
      deps
    ].map { |file| share"lua"luaversion"luarocks#{file}.lua" }
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX
  end

  test do
    luas = [
      Formula["lua"],
      Formula["luajit"],
    ]

    luas.each do |lua|
      luaversion, luaexec = case lua.name
      when "luajit" then ["5.1", lua.opt_bin"luajit"]
      else [lua.version.major_minor, lua.opt_bin"lua-#{lua.version.major_minor}"]
      end

      ENV["LUA_PATH"] = "#{testpath}sharelua#{luaversion}?.lua"
      ENV["LUA_CPATH"] = "#{testpath}liblua#{luaversion}?.so"

      system bin"luarocks", "install",
                                "luafilesystem",
                                "--tree=#{testpath}",
                                "--lua-dir=#{lua.opt_prefix}"

      system luaexec, "-e", "require('lfs')"

      case luaversion
      when "5.1"
        (testpath"lfs_#{luaversion}test.lua").write <<~LUA
          require("lfs")
          lfs.mkdir("blank_space")
        LUA

        system luaexec, "lfs_#{luaversion}test.lua"
        assert_predicate testpath"blank_space", :directory?,
          "Luafilesystem failed to create the expected directory"
      else
        (testpath"lfs_#{luaversion}test.lua").write <<~LUA
          require("lfs")
          print(lfs.currentdir())
        LUA

        assert_match testpath.to_s, shell_output("#{luaexec} lfs_#{luaversion}test.lua")
      end
    end
  end
end
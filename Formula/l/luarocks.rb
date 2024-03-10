class Luarocks < Formula
  desc "Package manager for the Lua programming language"
  homepage "https:luarocks.org"
  url "https:luarocks.orgreleasesluarocks-3.10.0.tar.gz"
  sha256 "e9bf06d5ec6b8ecc6dbd1530d2d77bdb3377d814a197c46388e9f148548c1c89"
  license "MIT"
  head "https:github.comluarocksluarocks.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{luarocks[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2cd1ff716492ea6a5b1b28076a7becc4414ae3500d26974827df353ee5b661e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2cd1ff716492ea6a5b1b28076a7becc4414ae3500d26974827df353ee5b661e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2cd1ff716492ea6a5b1b28076a7becc4414ae3500d26974827df353ee5b661e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c548631f8022163cce9d55f5b24bb222ff32f9456d33f42133772db2d5d40391"
    sha256 cellar: :any_skip_relocation, ventura:        "c548631f8022163cce9d55f5b24bb222ff32f9456d33f42133772db2d5d40391"
    sha256 cellar: :any_skip_relocation, monterey:       "c548631f8022163cce9d55f5b24bb222ff32f9456d33f42133772db2d5d40391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2cd1ff716492ea6a5b1b28076a7becc4414ae3500d26974827df353ee5b661e"
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

    return if HOMEBREW_PREFIX.to_s == "usrlocal"

    # Make bottles uniform to make an `:all` bottle
    luaversion = Formula["lua"].version.major_minor
    inreplace_files = %w[
      cmdconfig
      cmdwhich
      corecfg
      corepath
      deps
      loader
    ].map { |file| share"lua"luaversion"luarocks#{file}.lua" }
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX
    generate_completions_from_executable(bin"luarocks", "completion")
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

      system "#{bin}luarocks", "install",
                                "luafilesystem",
                                "--tree=#{testpath}",
                                "--lua-dir=#{lua.opt_prefix}"

      system luaexec, "-e", "require('lfs')"

      case luaversion
      when "5.1"
        (testpath"lfs_#{luaversion}test.lua").write <<~EOS
          require("lfs")
          lfs.mkdir("blank_space")
        EOS

        system luaexec, "lfs_#{luaversion}test.lua"
        assert_predicate testpath"blank_space", :directory?,
          "Luafilesystem failed to create the expected directory"
      else
        (testpath"lfs_#{luaversion}test.lua").write <<~EOS
          require("lfs")
          print(lfs.currentdir())
        EOS

        assert_match testpath.to_s, shell_output("#{luaexec} lfs_#{luaversion}test.lua")
      end
    end
  end
end
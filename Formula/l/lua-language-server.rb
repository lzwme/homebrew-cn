class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.8.3",
      revision: "6b5e19597d88a219aac73cbccd6f88a4213e07aa"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29947d3ea0e82b77964cff6c63435a2b428c11d838d82e9170acddc6ccbd0e69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081dfbedb139566f1f48e37ad7052de48f5c95a67484356a7ac93418ecf82136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "138e56f1febfbe3b01bf204f63d82f84a14eeb947f4d94134caaf205473facd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "24ecbe9d663edcb810d54a2128e7676aafe33c1fa5ba327af08a5a0b7073d3cd"
    sha256 cellar: :any_skip_relocation, ventura:        "ef00f4d284f2b62596531c7cdbca25cd6358e5f8715a33d3ddfc1b17c4a9f649"
    sha256 cellar: :any_skip_relocation, monterey:       "8625da9607224aa23ec7dbeb943e903e45dd28e8312eff4f9a6a4f445c01049d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b04878b5b56c74a5c33e88c615594bff85e00fdb09a60d2119d5e9f08f453c4"
  end

  depends_on "ninja" => :build

  fails_with gcc: 5 # For C++17

  def install
    ENV.cxx11

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**3rdbee.luatesttest.lua"),
      "os.exit(lt.run(), true)",
      "os.exit(true, true)"

    chdir "3rdluamake" do
      system "compileinstall.sh"
    end
    system "3rdluamakeluamake", "rebuild"

    (libexec"bin").install "binlua-language-server", "binmain.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec"binlua-language-server"
    (libexec"log").mkpath
  end

  test do
    require "pty"
    output = ^Content-Length: \d+\s*$

    stdout, stdin, lua_ls = PTY.spawn bin"lua-language-server", "--logpath=#{testpath}log"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.23",
      revision: "dc15ea90474e63c5203e9504f44aeea0b08db99e"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12f94faeb96168500599b382e8fb51aac04bc47b9f84327b675896c1b167c0d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cdae613c4b85aefe8b48c7bcaf8c1b989ad7c1eca6a801ec77bfa3a54a62b75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "819e29238d2e1d4b3d974aaa3ae2a6fe930075bb9ebfac3b73e83d65b1e254a1"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd03a3b399b6719168933c55642cf777db2901a921bc6cb11a4d5685a6a46b5"
    sha256 cellar: :any_skip_relocation, monterey:       "13a3cdea6074bbed0ebbde432afa2dd42abffcd0b81e54bf40c7728a54b0550a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7447b395e76983fd88b5275f0f384c48795d3dc2d46e108df1fd829522405524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b698eb63e9473542ba859a7c6083e7f1203f93868aea6a3bc6e3976652fd7f22"
  end

  depends_on "ninja" => :build

  fails_with gcc: 5 # For C++17

  def install
    ENV.cxx11

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/3rd/bee.lua/test/test.lua"),
      "os.exit(lt.run(), true)",
      "os.exit(true, true)"

    chdir "3rd/luamake" do
      system "compile/install.sh"
    end
    system "3rd/luamake/luamake", "rebuild"

    (libexec/"bin").install "bin/lua-language-server", "bin/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec/"bin/lua-language-server"
    (libexec/"log").mkpath
  end

  test do
    require "pty"
    output = /^Content-Length: \d+\s*$/

    stdout, stdin, lua_ls = PTY.spawn bin/"lua-language-server", "--logpath=#{testpath}/log"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
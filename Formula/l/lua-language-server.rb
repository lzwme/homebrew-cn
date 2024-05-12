class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.9.0",
      revision: "0df588358e9343ff50f1d68b12d971e50bbe7e7d"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab178d0258fcdbdb10189b3eab3da0a355ff95b95c75eb6f0555eaed3c373526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22eb620ef3d1c6bb4c348728dc5fc968918fa2dc450c0bd3e07e0692076bee23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2da549315058b1d7acc84957cbd179dbd644dd9a9fa2db7908179e57bac04e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f5eee32c247ba2477baaa4f66e6c89d530ef12bfb82e4077645d1402b8cf25c"
    sha256 cellar: :any_skip_relocation, ventura:        "263d7c5c94616b57e86d834ada532bb5665877a75b8aec0a144dd1ce9620b891"
    sha256 cellar: :any_skip_relocation, monterey:       "77e25e1d953684f0c4950e509fcb6f0925b797e626438c9e055a98de75c81f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbbaa364d96d37b62392ce5d4bc94daacf860cd594da29b059789eee5561d8f1"
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

    # Make sure `lua-language-server` does not need to write into the Cellar.
    (bin"lua-language-server").write <<~BASH
      #!binbash
      exec -a lua-language-server #{libexec}binlua-language-server \
        --logpath="${XDG_CACHE_HOME:-${HOME}.cache}lua-language-serverlog" \
        --metapath="${XDG_CACHE_HOME:-${HOME}.cache}lua-language-servermeta" \
        "$@"
    BASH
  end

  test do
    require "pty"
    output = ^Content-Length: \d+\s*$

    stdout, stdin, lua_ls = PTY.spawn bin"lua-language-server"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
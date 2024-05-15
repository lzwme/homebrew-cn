class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.9.1",
      revision: "e89d53912c6189448e721f5e3a012759538d0da6"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deacdf4c0cdf79ac1e915b85cd552b7932fc462903007232a27a8954271a09c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8f40b39516c1bd321c9c7526b42adade22d3956a6f9482087ff351eb108d187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7de645ac5ab6bb9009733b6c1bab427e52708e4ee32af948153d05a702d8f026"
    sha256 cellar: :any_skip_relocation, sonoma:         "579c48a51e371bf239b8111e0ee55d033b314f18cefdf3782cf1fa00d951853b"
    sha256 cellar: :any_skip_relocation, ventura:        "99bd7f30f1abea6cd929b71c222ba1f95470ba61283b62c8f8b7a1328157aaf1"
    sha256 cellar: :any_skip_relocation, monterey:       "23cfe0ba431f9870e301cce5e6da1349a0232e679b2381b62050721160f4096d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1c327f92ca8c9276301bfdc87448d7d254748562b38eb41648588ef5933567"
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
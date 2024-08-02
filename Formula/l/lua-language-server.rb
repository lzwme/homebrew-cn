class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.10.0",
      revision: "bd0af02e9708fd901b3d17bad502b4ef8949e4fa"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fbc8a742baf4e4c924f9d04a050561c747ce3451328341f1d8b38f426bcfcb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "147db972467cafb71ec4668adbe2a5bfdbbb9a722d40f4b2406cb570dd114788"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0087e0e3f16d43a97cbf770effcc5d6ad9b8953455c4a40d734b3dc18f8d7754"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd3d406bd3226c9e76ff50a6a09fd27de046c0a6fb4534a95a6f86eb3c8f6703"
    sha256 cellar: :any_skip_relocation, ventura:        "b43d3d02df403bf3a6e85a7971cd79de6a07f283ffc12a68c158528976c0a57f"
    sha256 cellar: :any_skip_relocation, monterey:       "2dcc394561c092edf392bcc225d9aabd6cf5fbbcd2eb46d3548426686f852fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb7e2f6dd38244f445cbb9c30e48251de00b78304828edd7e9a4bc4626283f3"
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
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.10.1",
      revision: "26a7b690c7eeb1a209b1b600886b2ac6691c5d2e"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17c32ce606d8a0c9dce0ad534c438561c19c06bc7aed42bec5eb23e39006c2e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "775aed8e06f848fd1dfa5676994ae5b9a48d929ba972ad69f5996a1f79109533"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b999a008bb7cdd87c78f0645f2079eb1f4fb3c3a8cae0b8ffa1810f2e3221f17"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb3fe48b823c93f1b9ce2f077ec5f8f0b4b1af1b74a9939072a53c0d53f68228"
    sha256 cellar: :any_skip_relocation, ventura:        "1718438126093f7e6003c65044c0b128d0c9144adeef9e52ea4ac752407f0960"
    sha256 cellar: :any_skip_relocation, monterey:       "ff0a4d12c8bbce071d9f3f00f80f5107baa6348d854468b9f14a6eaeeb0b5b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32bbe62779d6622cf7d59436a7ce2753d0bcddb32961b62fea4c3a98ad13c05"
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
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.11.0",
      revision: "f65da067bb05f0de0e188b7c7c9d4ee0464de795"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3901a14c08130f10cd9756d380fad28cf95f16778eaa7dc6030304378729a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a96a8e22bf3d9fd3113cb70e659a2856234206b7a8a0ff516dfefc6e48c054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6154ed6430bec1e69d7de471cf7c21b7253d1755fac0d5ac44a09895eb8b7a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13751fedd919f56cdd7875822e1169dd5991580c45e3c8e3fb474ade08b2de4"
    sha256 cellar: :any_skip_relocation, ventura:       "f05447961562bf8669b8cded07391e65a9f33ebf7b71e880a6fa0f89d9efc11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c452ab5eb41ba2c2a737ee75ee79bedb40ca03b6877a3a48461686cd047313c5"
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
    pid = spawn bin"lua-language-server", "--logpath=."
    sleep 5
    assert_predicate testpath"service.log", :exist?
    refute_predicate testpath"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
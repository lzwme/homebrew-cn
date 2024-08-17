class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.10.4",
      revision: "d702a55715df19a219e963da496e6fb76db0aacd"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198366ffa68f05a17426fb45dfffa0cc46c24312ea053d36672e18c2efb96805"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1d2ea9c94cb1ba79b3dd3101e9c2acb7f5ad95c92914a10bbda5a5d6b64df1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc8d3dc80e0b977b20ced45242db83f97fabe038c0ca7a20483296c93449776"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c2bca84702a26076af9deaa6fdea0933ccf8e772b41c89ae28cb4ce41a79701"
    sha256 cellar: :any_skip_relocation, ventura:        "44f256bd4791e6356b08b700467a35d616089589df7df4e1aa532227462f5332"
    sha256 cellar: :any_skip_relocation, monterey:       "96220a46add71d83dd04eeb0a0f56b81627cce9dee45a5e76d4754518194db16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab595c5fcddfb7c363439a02469d88b4221e5290659af31f03e9036bcec4b61"
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
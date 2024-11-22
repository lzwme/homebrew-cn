class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.13.2",
      revision: "1bc01316af663092fa3ffa79e6a419a5b956e4e7"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9139de34f0f97d82f23bd8e94a3a968074d4c58cadb5aab25e1c4c2584610797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc6cc30833459e0c1262da27e28a96f0bb735e823fd8eb8fbd09a5d78c87f797"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bde3e2de51404a2a608d2b39dbeb552d2730bbfdb61ed6d418f003e9a61ab1a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "72cffc4f9a6c5edacc0369a8fa7c95a3bf83edff2b546f94f403440e0b7f8ac6"
    sha256 cellar: :any_skip_relocation, ventura:       "46b2b963e070f5927f4757edaf8c06d3172dab2c739a42121efe97704606bcfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55dff21d87becbdd3708b3af456de8b8cb21a6a3f89d88e79d448e5f2f1c52a9"
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
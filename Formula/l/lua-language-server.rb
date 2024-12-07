class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.13.3",
      revision: "8d3a4c8175d4f0d42257ed92fa3550eb6f9d0f29"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79deedcbde2dd8e1ca1e5448b905dbc0138b7af350ed7842452176a64ac5ad58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405563f0f1d5983a009ec64e1745815803cbf36a239ee9a7f0844bfee4f22dd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73482e50ba22a630b1876c61f94c5d2ab046d65e7bca824562692815df7cab9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a62aeba1a162ec8efa0d9e622f3e12e45ecf6b2a6bad2d4968e1ca40fd3434"
    sha256 cellar: :any_skip_relocation, ventura:       "ead4ad238ba7e1ed9c9eed23e68b37090e1a9a9b14841c606cb6ed820e341982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a153ed4a3a76daddf52e6d414ae740d241c6f976cc1339baa929ba8f44a8676b"
  end

  depends_on "ninja" => :build

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
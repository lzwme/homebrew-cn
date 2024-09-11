class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.10.6",
      revision: "44b632dc0b1969d0a503dc18419731249c6ad267"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "13e580e0c77d8b33b0dbf9e76e0c79c6de7d9a53fcbb654f90591b997832e68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b210b7bf351d075673660597da5093d13030ed91c9c60989bba0c8ca7c0b171a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb42fe53347f2c2b3679d666165abf4559095a4c5cd0a68ece83590b1ce1ec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f713620f4c17efed6fdcde78147b39a0ca721ab4e2eea2fe5b964f3d2d92cb32"
    sha256 cellar: :any_skip_relocation, sonoma:         "c44b57ab3783c5da8bee4e70304f7ef71e65041cba1cb0838027e5020cec9ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "2dc6d3e8319a07479eb1429da208dd4e5b9d187f2be2001695d49e8c81bee3b9"
    sha256 cellar: :any_skip_relocation, monterey:       "09c9d006838c5fd10385325ffdcacde3585c8197c99a547a49e1b5780cd64953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb054ea6e10f392057380d86cdfffd05c36f2c022a28c6eab3d4d2faef314e05"
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
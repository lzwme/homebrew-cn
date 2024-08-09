class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.10.3",
      revision: "aaf16240f77bb75a3d8db89c2a99934c8b6022ee"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cc84f4dc8437eff86c028944ddd4bbe7ce51094ed3c5acb6bfd5948a36f5f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e089fa48575fdfd8af99ca752322dd41fd9761a6940de3d3ec7fb215e8dbd19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "935320a0cba5882d7e973a7d53b4bd8885ec900d52e707d5dcc18e306a8f3fca"
    sha256 cellar: :any_skip_relocation, sonoma:         "35709d4bce6a5d1f56914261c5746e7326bc1d695a0b0adfb2d6296dcec52c51"
    sha256 cellar: :any_skip_relocation, ventura:        "2489278cdd1fbb32e3a3993f3f116bc665a67d88b87d3323803a3a813fd25f7c"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5baf7af8c38e893650d7aa78e2ef7c94f7d09252f002c7c51967397731cee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e9ffaaa7526f94abdbd9301dfee8b961e327be2da191715d1d5acec5c022c7"
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
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.13.0",
      revision: "43ad9693819244ebe2e0560bda4bd494b067a1c7"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696b1d440b2759c80c5daa84afb3169d913c06215b23065e6705c018ce0ee091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712785ee99ede65fc862f7411478b9c394a4cc3f488078663044bd532a8607bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb82a0a278150df14e3ec45cd963f0560229c1eb824cd0b47459429861065be5"
    sha256 cellar: :any_skip_relocation, sonoma:        "595b8c8ab0a24a2ca2948c81527dd96d752a44e81662a8f979e9cc0309f9051d"
    sha256 cellar: :any_skip_relocation, ventura:       "d0cd9f7fb3172aba3aace24377a2423f06be8ddd0ddef8bf1433b5f0017501e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620d91dbd4975b0d6ee1a745ed2670da4188ac5be26a686dc7450e91042ae2be"
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
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.13.7",
      revision: "9f8c898aa997255fb931bae52f9b3a9c1f5c107c"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "716ad026ed84a33fe54506c4e64902acf775e05d609180e64c5b410e1e5b0c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aebce8ce46e64da3ad82d6db833ccc9e67ed31310d86b6d6d5e5619229f5bf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e7f16e225375b429183ac9ec31c47d208ef8d9451751ace22e2719431e1f5e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8296a60b6453302e51ea2fc6405eef94fa8bfaac6751dc47bfba451416feecd3"
    sha256 cellar: :any_skip_relocation, ventura:       "51a67852a82a087a64fa5bebab1207f867a3594898f7aae817280b1c854cb274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea3b4816f2a0b4b6d9f21e9f9017e90ed790da1095cdab9219534d341fd3208"
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
    assert_path_exists testpath"service.log"
    refute_predicate testpath"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
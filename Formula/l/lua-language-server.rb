class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.13.8",
      revision: "7be92d2c57853c632252cafb88c2378e4465d5a5"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e3a3144900248d42136631a859659d95e7828cc8f426ac7cbb5d706eddabef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d859274ee659fa31e1b0bf5848e1bde9aeaccd2f8512c02d4a7e0a98022bcbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f7c51b658e2593ed9ad570738aaabadd3415fff9774420329458c09307239b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82a9b03a84ff44486624b8eadcdb43810e1a98377b0f7f4fc473afe3f6d3eda2"
    sha256 cellar: :any_skip_relocation, ventura:       "4e20d73d5075783fe2d404d37e665490aa0d288a6ae4c0aa4397afe725556e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97051bc2f7fb45b36633a7fdfb3825e3452457f980eb4175f37c4502d068603a"
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
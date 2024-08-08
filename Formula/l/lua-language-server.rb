class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.10.2",
      revision: "db509e65deab282b89022d27e24767e4a07b8ff6"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9383f0e83a3d3b153fcf3a00c91b1ec63197de58ec3443c97e89f64f8373b22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da8534e49040bb5253d81960b4ded75fcd903948693438af94c0d0c6339f78de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdabc148d7396255185025ea1d8a4f495f0615bcfcbaa242e2cbdd685cf9c2bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "796a0f1df1c04e4893b8256537cd540b0cd60abe3b737c392a20094213eeb726"
    sha256 cellar: :any_skip_relocation, ventura:        "56d8c4350895a2bc924aef4c7da239b711f70419f7eaf184c68d6908172fb69a"
    sha256 cellar: :any_skip_relocation, monterey:       "5b9859e22908d339e23225b0a82afeea6e6eabfee919d3bc8d95c4927bdcfc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dcfed6a6664cd139c5d12b24f2ac7107b16f99c21f74c862299b8790cdb2105"
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
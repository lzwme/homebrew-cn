class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.13.4",
      revision: "108ce76c99bcb9990421edd4453a2ca8e282af95"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd1e2d5534d22356d6cb3f051ea0d3144c04dca625a9e59c8f389b3fd7600cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "028cec884349296e84f0f43870e550edf4d007094aa791948176b43a5d34c782"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17cf5304937bc620ac89da8bf8646602dd90544bd22b314e108dbacd9c0fe7c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "73f3dcbdb20d70703c63f296120ed0fbaf2cb8f49b3582c96a74bd8f0c32c508"
    sha256 cellar: :any_skip_relocation, ventura:       "941a776f46bcff1fcd7ec9dc789814f41fdfad2ce0432dadf9ea8df692c72304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda4134f49fc8423150c94a3e14a2ee273e2bce89bf7ebc2ec3961c47e387cf2"
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
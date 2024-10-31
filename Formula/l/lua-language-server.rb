class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.12.0",
      revision: "389496827f20bb6d75a2fb2826099f13e9c18730"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc1b0e3c0e2996da3065ec6e4cb15be4e3474bf836ae101c6a92183c49e374c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a0f391ec014a7fcccbf9662913d75ef3fbf102705b1f47b8d08d859c5ae80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "005a2c01ff8640c35633bf755acb2822b7e57213c1c20df8f5a6f77b251e0d55"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3f502a7827e8a35b464a820a90b51b0a315d786d1c284504e0ddc6c67158834"
    sha256 cellar: :any_skip_relocation, ventura:       "0b7a958c166cbdb856ed8d09f30e4695739a006c858d746800718cfa5a386fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114a608060cceeaa0537c18a429eda09356f4aa554be7c6897b2a13e62cf207b"
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
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.6.24",
      revision: "ecda29f02cc99304b254a7677c65aca8e8f457f3"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c2fb1cddad71002dc244de79a994a4246d004353f60b5a31b5d6a1649ea208e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a16a20763d29e6ef2299ac2de05bbff4ec92ef5907eb42caba15160022f8a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9544f06488949accd8ebe838e6093e73387ee27d0648ad015ebbb7c9cefca31d"
    sha256 cellar: :any_skip_relocation, ventura:        "f791d9e4418633f92017e747605dce36b9c47d9cab281e91641f8f94e1c69997"
    sha256 cellar: :any_skip_relocation, monterey:       "3e3787c5d10f834d8afb414e9c9ae036f05cc094cada35ca2759d8dc2731ea1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "41b668b910b2d5b15069942f0bce0f231516ddb660bf16031d19b6f02c34df62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b7fa3322949d0d5471cd91c9b9265a258f0f079c813142de38b11c1be5d053"
  end

  depends_on "ninja" => :build

  fails_with gcc: 5 # For C++17

  def install
    ENV.cxx11

    # disable all tests by build script (fail in build environment)
    inreplace buildpath.glob("**/3rd/bee.lua/test/test.lua"),
      "os.exit(lt.run(), true)",
      "os.exit(true, true)"

    chdir "3rd/luamake" do
      system "compile/install.sh"
    end
    system "3rd/luamake/luamake", "rebuild"

    (libexec/"bin").install "bin/lua-language-server", "bin/main.lua"
    libexec.install "main.lua", "debugger.lua", "locale", "meta", "script"
    bin.write_exec_script libexec/"bin/lua-language-server"
    (libexec/"log").mkpath
  end

  test do
    require "pty"
    output = /^Content-Length: \d+\s*$/

    stdout, stdin, lua_ls = PTY.spawn bin/"lua-language-server", "--logpath=#{testpath}/log"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
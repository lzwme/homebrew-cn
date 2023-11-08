class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.7.1",
      revision: "5a763b0ceecc9a817c8ce534dc726f5f6f6e1ac9"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f2fc77dc7bcb363c83ff5d9cdf08aba3e89dd3a25ab34f64ad83ebf6b993afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62e893fe3193a9e7bc096da43380756665deeccc717502196f30d8a4ff88d51a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3cfe0f0ae495e23c7b594989e2248755294674f391218dd9c4d1a89cba6a900"
    sha256 cellar: :any_skip_relocation, sonoma:         "72939af59cd650fa171aa11d6b7e71748ad02f985b77c8098d01a9fcba65b012"
    sha256 cellar: :any_skip_relocation, ventura:        "e2feed0a6fb967c3b8389fc48ed2bebbd882d40deddc35f0284096b2f9662e38"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb10baf0cd0a31c09325e22f841cb620e1ad6203a886e82a630f1ee7592cec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa5f550e2f501bb37e6c3792da593d6dbe6a5b58c02ce44003980d0729be4a0"
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
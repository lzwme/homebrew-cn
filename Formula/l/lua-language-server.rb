class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.7.2",
      revision: "ee590a4cd1bc972ffe19e232b176aa1ffaba2d47"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9db8acd6223eddf2a9a80e52d71309c509092b596dca8ed4da9e8e0818b36ec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57f03432bb6aef15ca8addd45ac209fdefbe062230c9b28a360d21771c073f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3498bf18936b181c2371683ec92038bf7775da41f0a9992e0aeb29d0d569a635"
    sha256 cellar: :any_skip_relocation, sonoma:         "5902b02f6558a6a5dbc30a5aa4aa15178123486ad6dda79354a1475defeed309"
    sha256 cellar: :any_skip_relocation, ventura:        "9b181c1fb36f89dd82f2fdffbb9b02703e5621c48136cf4ccb965750b5cc0464"
    sha256 cellar: :any_skip_relocation, monterey:       "687f6f9c55c09377ae26d6e1d0b4182d7253cb94e98c95f9ef936fc1f206f8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0eff48414ae235f7d2ec2e154f21fa422602ce46090596081790c1fd1ddaee7"
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
class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.8.0",
      revision: "5d9980edae90a71842f69ec13c13ac451f64e090"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9f3736200fa5c1aa89e124255a93c5e1fecf1fc2204cde437e92d432564c266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88124fc5b60e59ed0e7a9ba333a4939cced033ed8c15b4745abd84cb8b1c54e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5709fa679e9a94a954e4692a4461a5a135c33a423b6d4974b04552740e378b7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3324f08a2011478877da40f2abc3d043618625af4a9a1fc36beafd0b826490a8"
    sha256 cellar: :any_skip_relocation, ventura:        "8196d754701b7ce7949368abc79a6a2e21065eebf0f8a7225e1a2c7ee4bf2db7"
    sha256 cellar: :any_skip_relocation, monterey:       "5e79629f78640fc98ab6aea198f9f96ba191f4f0b57d2f295753356612909a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44a1f196baf1ec3c744117643dd3bf2e02cf52f7334089267ff6b07d24f6fdd"
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
    bin.write_exec_script libexec"binlua-language-server"
    (libexec"log").mkpath
  end

  test do
    require "pty"
    output = ^Content-Length: \d+\s*$

    stdout, stdin, lua_ls = PTY.spawn bin"lua-language-server", "--logpath=#{testpath}log"
    sleep 5
    stdin.write "\n"
    sleep 25
    assert_match output, stdout.readline
  ensure
    Process.kill "TERM", lua_ls
    Process.wait lua_ls
  end
end
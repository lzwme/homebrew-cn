class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https:github.comLuaLSlua-language-server"
  # pull from git tag to get submodules
  url "https:github.comLuaLSlua-language-server.git",
      tag:      "3.7.3",
      revision: "50dfc81e075be5fe2cdf7b2b94007dd5ed2edefa"
  license "MIT"
  head "https:github.comLuaLSlua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "542147443413221dd43ee9c93b1c8f40509ba959221f0c41fdc80eb34bc6e019"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36b2122ce7d6c8264a958e035d9ca7c68bd8ca03fef7406dfabf5cb1c81b5294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6810e6148e4e60ec15722135268dea93f1c23b82e2d037b10ba6fe4057cad97"
    sha256 cellar: :any_skip_relocation, sonoma:         "26056eeb2c38ce80b9bd4fb8d7b51b47ab99b99377be3c35592316c5c54ea5b3"
    sha256 cellar: :any_skip_relocation, ventura:        "bcf38167df2782d7e499133352493e3e70ba3d094f9988ca1b86d272552adde4"
    sha256 cellar: :any_skip_relocation, monterey:       "77efff06a312313116c47337bdfb1725f5509fab285a0732d703a6bb0d7530d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bd02f6f55f54fbc0d346b3cb7064614d3a1d92044f2b624d44efc9236bbee23"
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
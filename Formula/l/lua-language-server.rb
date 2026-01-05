class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.16.4",
      revision: "af7bea0b05b1c11d2579db02de3ccd32224b5ccb"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "304638afe999d206b0f349f17f7931f4dc1ccb68c012a3e61bdda98d97568383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f4681b980954d8df87b0d30210edfb8b05cb907346a3eab76eb3ed53dd0b143"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3da0f939da9d385449f15c20b625df8f75ef9758893c8d80d039a1e0c13fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ebf685f5975b9176134becbf4bfe877cfa83c0a58ee24c4cc47077f7ea3c3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb923264cc411ad9092603efa18023efcd7f5c66248e71dce65b73f22832a35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb4ec4506c0a178b69f57beda66a94402f92578853313c38794f750bdf37bfa"
  end

  depends_on "ninja" => :build

  def install
    # Workaround until upstream can update bee.lua submodule
    color_h = ["3rd/bee.lua/3rd/fmt/fmt/color.h", "3rd/luamake/bee.lua/3rd/fmt/fmt/color.h"]
    inreplace color_h, '#include "format.h"', "\\0\n#include <algorithm>"

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

    # Make sure `lua-language-server` does not need to write into the Cellar.
    (bin/"lua-language-server").write <<~BASH
      #!/bin/bash
      exec -a lua-language-server #{libexec}/bin/lua-language-server \
        --logpath="${XDG_CACHE_HOME:-${HOME}/.cache}/lua-language-server/log" \
        --metapath="${XDG_CACHE_HOME:-${HOME}/.cache}/lua-language-server/meta" \
        "$@"
    BASH
    libexec.install_symlink prefix/"changelog.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lua-language-server --version")
    pid = spawn bin/"lua-language-server", "--logpath=."
    sleep 5
    assert_path_exists testpath/"service.log"
    refute_predicate testpath/"service.log", :empty?
  ensure
    Process.kill "TERM", pid
  end
end
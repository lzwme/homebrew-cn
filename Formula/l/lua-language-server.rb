class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.17.0",
      revision: "dada769755a5d657ffd8ed584951bba18f5e3322"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b08aad123975a725a765a4f05629b49cd0c03833b836aa6c8e10ee13657acf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b692687b33b776e2c8532c773107e4828deaf5845cb223b0027d5003f7eb46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a8f29c461a09a5a541b6c2257312fb0186ca3278e7a3e9d6492e76381f6a36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d7dff8a953dfc114efcaeafa4f6ae6f36f3fcfceda5e77194331ff69eb4a638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeed695f7e6a5faaab4fff2be6e4fb2b45da2b84b77e213fa56dbd2f7c9a417c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660ffc0a1f273ff95cd487186e1b891491fed575ddf776ea5d60fe133fdef57a"
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

    # remove git metadata from submodules
    rm_r Dir["meta/3rd/*/.git"]

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
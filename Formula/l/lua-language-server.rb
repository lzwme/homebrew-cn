class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://github.com/LuaLS/lua-language-server"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.15.0",
      revision: "32fec3cc99af8b9a1e45c2455a8c3bd0d3e38f66"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab48d1402bc65a475f90da76e03eaa4a93396d40eaffb9566c24a43745f27888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d5a3c5ac7dd70da1cf14fbd44ff035cd7dadff077dfae65b9ce1fec7891635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ffcb34b7af2bbe454c86eae301444826159e0d937e1d7590901b51467fd4465"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c460a8f92c363e9aab64eba2edc5a3a87cebe8dd6ecac2b9f24ce62e0b07049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b98fbe3eafe3fc1b4a61c467ddd600322314697252e31ba50f0890b65b285ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "968ecabb1580b66366d71a8af6b86cb7731d48ee3817fa60d112853b4b436530"
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
  end

  # `lua-language-server` uses `changelog.md` in `libexec`
  # directory to determine its version. Installing the changelog
  # in `def install` does not work because it cleanups metafiles
  # from non-root directory
  def post_install
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
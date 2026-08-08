class LuaLanguageServer < Formula
  desc "Language Server for the Lua language"
  homepage "https://luals.github.io"
  # pull from git tag to get submodules
  url "https://github.com/LuaLS/lua-language-server.git",
      tag:      "3.19.0",
      revision: "c0685017061a4ec2c9fab575818174abcbacbcc7"
  license "MIT"
  head "https://github.com/LuaLS/lua-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4ead63529e42d5868ed76fe6126620f2822e489f4ad57b4c659549fba53c558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dee7b191fcb6642e35d439881e2f0610321f786afcfbe55ec4782b09ddf90028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e1e0f8b679126e4b9dc48b78294ff5c8806547638e155bfb0d9d2ebaeffcd36"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade4705ea4ed2b01ceed975c93952b59e7f6429c04c5da179c35d716a24666ca"
    sha256 cellar: :any,                 arm64_linux:   "d179b941a591af013720bf84b9a0a9d7e99bf8132ae456e35fbe1076c6271eb5"
    sha256 cellar: :any,                 x86_64_linux:  "5e3748783874802e61f9facb440ec6bdf06a83bb6ffce6430c096ffc5ea9e8f9"
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
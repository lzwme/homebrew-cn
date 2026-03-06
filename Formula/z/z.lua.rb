class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  license "MIT"
  revision 1
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/skywind3000/z.lua/archive/refs/tags/1.8.24.tar.gz"
    sha256 "ed749f4cdc9ca4315a74dca0918b1e12d5961b9c16754907ef492c4ae0bfccd3"

    # Backport fix for Lua 5.5
    patch do
      url "https://github.com/skywind3000/z.lua/commit/e1eb7a2104a258d575b0217009ad63e10fd2339b.patch?full_index=1"
      sha256 "3da693f9937aa3aefb958ab4814705ec3db712b0b36b40a8d3c763c073dc8ee1"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76b13c19325cf268b89ab38c5d79d36f9d5506f1a5e8dc7c038a491fa593ebfd"
  end

  depends_on "lua"

  def install
    # Avoid using Cellar paths at runtime. This breaks when z.lua is upgraded.
    inreplace "z.lua.plugin.zsh", /^(ZLUA_SCRIPT=").*"$/, "\\1#{opt_pkgshare}/z.lua\""
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  def caveats
    <<~EOS
      Zsh users: add line below to your ~/.zshrc
        eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init zsh)"

      Bash users: add line below to your ~/.bashrc
        eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init bash)"
    EOS
  end

  test do
    system "lua", "#{opt_pkgshare}/z.lua", "."
  end
end
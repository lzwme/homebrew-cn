class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https:github.comskywind3000z.lua"
  url "https:github.comskywind3000z.luaarchiverefstags1.8.21.tar.gz"
  sha256 "cab613b1ef752c84a318863c1d8d4ac1aad1699646a5052f67620a44a4a38184"
  license "MIT"
  head "https:github.comskywind3000z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad5ff87665c7ba4d6447a720162b11aaceed7fcf8ae16a92b4c3fa071275eb1e"
  end

  depends_on "lua"

  def install
    # Avoid using Cellar paths at runtime. This breaks when z.lua is upgraded.
    inreplace "z.lua.plugin.zsh", ^(ZLUA_SCRIPT=").*"$, "\\1#{opt_pkgshare}z.lua\""
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  def caveats
    <<~EOS
      Zsh users: add line below to your ~.zshrc
        eval "$(lua $(brew --prefix z.lua)sharez.luaz.lua --init zsh)"

      Bash users: add line below to your ~.bashrc
        eval "$(lua $(brew --prefix z.lua)sharez.luaz.lua --init bash)"
    EOS
  end

  test do
    system "lua", "#{opt_pkgshare}z.lua", "."
  end
end
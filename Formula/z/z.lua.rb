class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https:github.comskywind3000z.lua"
  url "https:github.comskywind3000z.luaarchiverefstags1.8.16.tar.gz"
  sha256 "28e6c9d03792efc45d7ae822b23d59d2ea3e2d4f3a12f37bdee5a797a2903d59"
  license "MIT"
  head "https:github.comskywind3000z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "519898201455e344fb16a32b50e5cfafcb2a7b59011ac8167d90e51c3d31d18d"
  end

  depends_on "lua"

  def install
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
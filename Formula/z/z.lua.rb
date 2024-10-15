class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https:github.comskywind3000z.lua"
  url "https:github.comskywind3000z.luaarchiverefstags1.8.19.tar.gz"
  sha256 "ef09629900421ff894df7e1cb16134e594e8af20364c900804c4a939fae48f4c"
  license "MIT"
  head "https:github.comskywind3000z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "feea8fd0e54478bee3b63e82e7ee7823edbea6813ee0c2affe41caac8fbcee92"
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
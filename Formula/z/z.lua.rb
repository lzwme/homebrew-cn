class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https:github.comskywind3000z.lua"
  url "https:github.comskywind3000z.luaarchiverefstags1.8.23.tar.gz"
  sha256 "36d8237d2a6f9b482cd9affeaeae8f0b6ff21a08e8f9a747a1b5722d290e6fa8"
  license "MIT"
  head "https:github.comskywind3000z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87586a51ef47b1639147ef246712552f159a3704da45ba872de2f9b45ffdda93"
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
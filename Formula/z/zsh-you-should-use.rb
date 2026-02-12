class ZshYouShouldUse < Formula
  desc "ZSH plugin that reminds you to use existing aliases for commands you just typed"
  homepage "https://github.com/MichaelAquilina/zsh-you-should-use"
  url "https://ghfast.top/https://github.com/MichaelAquilina/zsh-you-should-use/archive/refs/tags/1.11.0.tar.gz"
  sha256 "dca42c9df5dd43875156eee1b1d6e2cd22122844a1173088c7d7523336851927"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "350034749860a420e21c835a98e25897706badc378b5cb66961aa64f33372264"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "you-should-use.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate You Should Use, add the following to your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c '. #{pkgshare}/you-should-use.plugin.zsh && " \
                   "echo $YSU_VERSION'")
  end
end
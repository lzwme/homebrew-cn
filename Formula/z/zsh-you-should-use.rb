class ZshYouShouldUse < Formula
  desc "ZSH plugin that reminds you to use existing aliases for commands you just typed"
  homepage "https:github.comMichaelAquilinazsh-you-should-use"
  url "https:github.comMichaelAquilinazsh-you-should-usearchiverefstags1.7.3.tar.gz"
  sha256 "db4486cd12974332ec858d446aff9393dae6be430d425a56d7036d2ce4edeb9e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "559c5067d040915063806f345fbf5470c5508766bb91208a92d2038b6d683f3b"
  end

  def install
    pkgshare.install "you-should-use.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate You Should Use, add the following to your .zshrc:

        source #{HOMEBREW_PREFIX}sharezsh-you-should-useyou-should-use.plugin.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c '. #{pkgshare}you-should-use.plugin.zsh && " \
                   "echo $YSU_VERSION'")
  end
end
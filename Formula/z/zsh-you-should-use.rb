class ZshYouShouldUse < Formula
  desc "ZSH plugin that reminds you to use existing aliases for commands you just typed"
  homepage "https:github.comMichaelAquilinazsh-you-should-use"
  url "https:github.comMichaelAquilinazsh-you-should-usearchiverefstags1.8.0.tar.gz"
  sha256 "a32337515d3c47b4d8a65e7302433d570de296741c48e3137b1d2c788e4e7d28"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "45fd1bf7f78aeed8e96f5a6e883a31f3715a091ea27131bf466fa3176f1e0df5"
  end

  uses_from_macos "zsh"

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
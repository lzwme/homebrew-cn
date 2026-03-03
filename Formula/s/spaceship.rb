class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://ghfast.top/https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.21.1.tar.gz"
  sha256 "d0b93fc5b8531cd393b533cde47d27d8bc7d0c45423d1ea3a5006e4ecbc78f9e"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2421657d8dcbacf2b8b3b6f855b852558f734265d37832713e5f9e1acd1176b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb18330c87bf3386c39397152cdeb50c528c0f5277301437785f34ae25df39df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de90f63c9c2d0888a955fb6b26f2d7001f9d98e9810da2193814b53573116d8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "424db35acba28ca4391c38e16f4190c1e54bd59295d9fdb4c2724b45c8c35782"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09f164e70cbb277f7e6ac06836fb2a60779644520ed1ba8032b2f50b134683ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab31e4ef50b85e128051345873cdd6459a9d95d4ad7a429a6f043a45b1aec567"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
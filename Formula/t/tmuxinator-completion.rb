class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https:github.comtmuxinatortmuxinator"
  url "https:github.comtmuxinatortmuxinatorarchiverefstagsv3.3.2.tar.gz"
  sha256 "8b5a8cc899f48772f2a8bace06ff463c57248ad9575a668326f1e60b7e9616f0"
  license "MIT"
  head "https:github.comtmuxinatortmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdbde07cdfa7d917cc0a16b4c5ef09d827d403e782a95f66b6e3369821906581"
  end

  def install
    bash_completion.install "completiontmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completiontmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion*.fish"]
  end

  test do
    assert_match "-F _tmuxinator",
      shell_output("bash -c 'source #{bash_completion}tmuxinator && complete -p tmuxinator'")
  end
end
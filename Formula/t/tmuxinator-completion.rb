class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https:github.comtmuxinatortmuxinator"
  url "https:github.comtmuxinatortmuxinatorarchiverefstagsv3.1.0.tar.gz"
  sha256 "5d5a2d0bcfc507f5a4518fe5f8077cb449040a504d0701cdde59b63f927adbfe"
  license "MIT"
  head "https:github.comtmuxinatortmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07356d3774292178ffbe9431a22dd9b65dfcecab1fa0bc350b6c0d9c67e47855"
  end

  conflicts_with "tmuxinator", because: "the tmuxinator formula includes completion"

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
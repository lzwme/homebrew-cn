class TmuxinatorCompletion < Formula
  desc "Shell completion for Tmuxinator"
  homepage "https:github.comtmuxinatortmuxinator"
  url "https:github.comtmuxinatortmuxinatorarchiverefstagsv3.3.0.tar.gz"
  sha256 "e15cf0d7fc8fc88b89adbeeebacd8061620c759da060b1bccf93bf8541679061"
  license "MIT"
  head "https:github.comtmuxinatortmuxinator.git", branch: "master"

  livecheck do
    formula "tmuxinator"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1e3b63364bf606d2c968f4b0231874aee6e7ab44d73ce1e0067ea0f2a163ab9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32c35616dd8562fb18546e47a774d8f2dface7f7e645471e24bff8d56d742c21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32c35616dd8562fb18546e47a774d8f2dface7f7e645471e24bff8d56d742c21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c35616dd8562fb18546e47a774d8f2dface7f7e645471e24bff8d56d742c21"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4f82e19e51b9236c0fe732d52b075ae8b40504628cdc78126740d635abe353f"
    sha256 cellar: :any_skip_relocation, ventura:        "d4f82e19e51b9236c0fe732d52b075ae8b40504628cdc78126740d635abe353f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f82e19e51b9236c0fe732d52b075ae8b40504628cdc78126740d635abe353f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c35616dd8562fb18546e47a774d8f2dface7f7e645471e24bff8d56d742c21"
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
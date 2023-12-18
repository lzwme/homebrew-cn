class BoomCompletion < Formula
  desc "Bash and Zsh completion for Boom"
  homepage "https:zachholman.comboom"
  url "https:github.comholmanboomarchiverefstagsv0.5.0.tar.gz"
  sha256 "d107accf1fb84d9c245bb25383486179605d3b397c439c2f4690341283b0b2dd"
  license "MIT"
  head "https:github.comholmanboom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "041329aa65f67c47539617cd6b7a585d0abd3158b0f1d1c8314807b2b1cdecae"
  end

  def install
    bash_completion.install "completionboom.bash" => "boom"
    zsh_completion.install "completionboom.zsh" => "_boom"
  end

  test do
    assert_match "-F _boom_complete",
      shell_output("bash -c 'source #{bash_completion}boom && complete -p boom'")
  end
end
class BoomCompletion < Formula
  desc "Bash and Zsh completion for Boom"
  homepage "https:zachholman.comboom"
  url "https:github.comholmanboomarchiverefstagsv0.5.0.tar.gz"
  sha256 "d107accf1fb84d9c245bb25383486179605d3b397c439c2f4690341283b0b2dd"
  license "MIT"
  head "https:github.comholmanboom.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "05b587e612fdff3439b6618c062c1f7b5f13332e3b8e7645d80cf5d5f023d276"
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
class CondaZshCompletion < Formula
  desc "Zsh completion for conda"
  homepage "https:github.comconda-incubatorconda-zsh-completion"
  url "https:github.comconda-incubatorconda-zsh-completionarchiverefstagsv0.11.tar.gz"
  sha256 "584d5817e276f01f5d789e01ba5c6688667b38d3c9f4ad2cd735a9901e27aa33"
  license "WTFPL"
  head "https:github.comconda-incubatorconda-zsh-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e960cb656df12a852dc6861e660084b853f1eeb3ab3acd8569d78ccb23f699d4"
  end

  uses_from_macos "zsh" => :test

  def install
    zsh_completion.install "_conda"
  end

  test do
    assert_match(^_conda \(\) \{,
      shell_output("zsh -c 'fpath=(#{zsh_completion} $fpath); autoload _conda; which _conda'"))
  end
end
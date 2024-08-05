class ApmBashCompletion < Formula
  desc "Completion for Atom Package Manager"
  homepage "https:github.comvigoapm-bash-completion"
  url "https:github.comvigoapm-bash-completionarchiverefstags1.0.0.tar.gz"
  sha256 "1043a7f19eabe69316ea483830fb9f78d6c90853aaf4dd7ed60007af7f0d6e9d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f86348dd9abdb4b7a8c6353f29374d7432375920a0281e806f14d50b8673bc1f"
  end

  def install
    bash_completion.install "apm"
  end

  test do
    assert_match "-F __apm",
      shell_output("bash -c 'source #{bash_completion}apm && complete -p apm'")
  end
end
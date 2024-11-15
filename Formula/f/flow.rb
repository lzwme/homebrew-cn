class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.253.0.tar.gz"
  sha256 "f6d16b419816af64b4d218d367faa8437233334bf0a43a22e604071ff3cbdd79"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949b8db0748e81179085bf27ae9c748ad8e5bd047e2e277979ad4dad361d9001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2705d7dec7e20ec30fe3996b285469ae3616f0b1fbde9b4062aa389ad4b0296"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "336aa218b976052fa559ad7cdd42ff6b96f49d59e8d9700aec0bff269be9a736"
    sha256 cellar: :any_skip_relocation, sonoma:        "23809641a901c9d7306863dc1d3ae62032ef17faf97368e5443dce08b88f3891"
    sha256 cellar: :any_skip_relocation, ventura:       "07ce79130c352537d7a302965c4cf371cab9380754d5ea353f6badfebb02ae07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c772b44a07ddcc9b1f927cd8335e4b51e2f443ef257b00eb75ac8eddd01c666"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system bin"flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end
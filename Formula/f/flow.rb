class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.243.0.tar.gz"
  sha256 "6d8b77958e17923f5b1f5fab8b9bf46e082c9227ed9d9471959ff6eb87e26807"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c67718dbcf9d4b7b75cd270421b9f8bb90dd10b5ad69e6a4091fec9cf186cea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183a0043269aee9c5b828439e5f97014f958c81ce01bce1a4d67d16f7c97ac16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61d82da435c902463d44a4b705d2d91cb0dc5ff646ac740a7a7be35955261b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ef2a8798dfadfe0c01ba542811a52153300aa1f14ccbcfe29b1b820efc5bf45"
    sha256 cellar: :any_skip_relocation, ventura:        "abddb4c3c73c748bfcbc5fce098bf59107f1ce0d4a0533d38cd857b3c7815bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "6bc9219bc30bdf5eef595e4a0435818ccc41183da2e5360ae8f9e5c6090c0040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6d9ea036b414030dbfcbd5c4074e9774efbb4088fc9d56cbf4c43e328ae855"
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
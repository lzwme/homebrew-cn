class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.208.0.tar.gz"
  sha256 "cfcfc9ec30ddea7dc0b3ab439c375e7d8420ff2d9a78116b1ed10bcb326734f4"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f44944dfa9540264b307ea619de45248b21bfff498c2ec11057d967f8f296c40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30147a779f616cf5f69014604d3ad76c54f4c8e5289e12086165f8138e7df256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b30fcf8c3bacac3ac2bd954f96b0628b4793ab7b6ab1a25d9098479f1b558501"
    sha256 cellar: :any_skip_relocation, ventura:        "0759bd5f6e3b60cc37a932c86bbf93b4c81c7fd50cd9d282fe7337c622ef0b3a"
    sha256 cellar: :any_skip_relocation, monterey:       "6204a34ada820872fecaf402d373786d40244c760cc38c9ab924f64548d6a53e"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb638ec3a687230c3a7f160f2cc43978070a74dd4c4389c760a5e6b67c14610e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8abcf680006a53d0eea964c9e009f25673818aa912ba0ceca0592b84728e2f"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
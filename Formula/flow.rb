class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.203.1.tar.gz"
  sha256 "91bfde18558f5e43cd1501abb937c3661e4438ef81fafd7828414eeecee73009"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f17f86a12793aa23f8120e45edd464f6d9d1554ac9b6e4e7b5f3f86bb070fa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bcf25444ea6b4ba1c6807b33ccde4d7871c02bd18e03ef2ce78ad1f19e9b1eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "155288eb6ab1669e3de73fa1d7b056e92c70465636a138d982bcacc8fc7064a3"
    sha256 cellar: :any_skip_relocation, ventura:        "55c7699e5434bafcdaf90989da3b0ceac1f101a6677fe5919867b87700df8688"
    sha256 cellar: :any_skip_relocation, monterey:       "626393d8197abe7bef250e5e5bba897756917851ed5bfeb48f6fc831979ad91c"
    sha256 cellar: :any_skip_relocation, big_sur:        "382ff9617ba2ee2b7308bb05e87d288b40bb07fd2bf1743e6b70132c122cda9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4fc82be9a5888ceada771f2dec10c6c2b8b8b08ff9a80e8a0f0e30983e29a43"
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
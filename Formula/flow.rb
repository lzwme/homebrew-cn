class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.213.0.tar.gz"
  sha256 "db303a043a4eb19aab4a45f1f1f92a80b945432bed14e1a93549414b5e8525e6"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e57ce13773f089f36b35c61d4278940fc09ac0116485ec3fbd9fcd82f89ced4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b714f4d1d65b50c2270fab4a06e35ba1ced2d7e1fc47b1f917c384251a9c1a45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "321a6d0f640a505802542f665f2c7217dffa95699854f587e86e1a9ba3d77064"
    sha256 cellar: :any_skip_relocation, ventura:        "90a652a3fa996cd63e66a105cd25e8bae7bdb1b5b6b9a9be1aa578e2fec545d9"
    sha256 cellar: :any_skip_relocation, monterey:       "4b74d8da4cf76f9101d57de74e1400b4e0f61267b199e49387402c771a64bb3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "29ba920e3e03210efb1f7b35524310faafcf1700f9ffec258bb1e86a0160337c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69608685696803b1cb4a207109d92dd68885ab0ab445751ab2ac0221e63052f2"
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
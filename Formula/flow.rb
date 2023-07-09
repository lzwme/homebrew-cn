class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.211.1.tar.gz"
  sha256 "e7bdfc71c5bf173a5b74ec4cde818c47101e2c852f6596f261271aba4587bd1a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438304e0bd0b078ab46015c7689bd6c75f86ead9dee676443397bee086178a16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7e9ab58a275bb0b8a731243a6d262ab7a48a878c9475a5a748bd3132fa0c51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b7248e4f16972251e350aca1201c36f5a533b6b86cc20ece40bd6e51207c320"
    sha256 cellar: :any_skip_relocation, ventura:        "b2d8282819fffc72404f17a11f1acd786e59b13bca40ee6be76b1daa80611678"
    sha256 cellar: :any_skip_relocation, monterey:       "277e1f7539886cbccf5b6a1edd61dee463f886b09eef7269ac0fb16f8a1128ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "56be015d21cbc0830c3d5b0df24990f3c0df48320f9825d1040e3aca99657eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e01c5247e96414a8fab7520f462252de72fe55d570660ad5449ac9742b19c84"
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
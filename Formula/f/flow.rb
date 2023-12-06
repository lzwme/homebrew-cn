class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.223.3.tar.gz"
  sha256 "c0d3a43490c5f10cba1fd19e8a44421046a606884c12bb1fda5d2d916525d140"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a15e745e732e2a5f85498a4b30531089251cce2083d729591cad92a74f08a141"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f9948a09817f6c136b559cdaacfac13f71e6c98eb8d6ff7fd6b6716475eaf92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7baec1518462a920af51feee6bc9d2bc35fff893c6b1eae7595cf32d919cd7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a62e45777597ae5b4550154ac736abeefdedad2f9f85b206325e9a9dc6190c7d"
    sha256 cellar: :any_skip_relocation, ventura:        "c67542edef58b3b1c25fa043ce13242b4ee386a7e2f62543e4ec6aba80ef4b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "54208efddffd77077eb1bdaaf5debce2849005a2dd85694dfcfc249f8dcdb435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9880851e330359a8d9286b70faac4cc61c3524423d6d038e69ab80d450b7c1c"
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
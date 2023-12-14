class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.224.0.tar.gz"
  sha256 "9dbb187df1a1578a1aa59d897f8f8152abd9d405e24dab29dc1d79612e60ac02"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b44208f41dfa9f3f3369f166852416e3a5942cfa2c2e6ec1c4bd75d9a3b705e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76843b3a8b39e6267dcc1e6b8798c3646266b39099747987aaddd0d2aba85b1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d2e0646ac64e012e2e7ccbba73298d627ef11ed2ecbf625d18e59c4db21810d"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcbac0a9625855316dac033fea4eb6b67c5f121c016373822d135b040809342f"
    sha256 cellar: :any_skip_relocation, ventura:        "29808de386a4ffa56aeec6ef89eefe1a2c0179223e85586423756e55f0a3e8f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4264c35f2a8e838395df7c0a391e9e587de8acca9593a3164de2ea7da188ee63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c180439ebeebddfa630c81f0ef7b22f43f062b6e26b4c31886b93085f8b9874e"
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
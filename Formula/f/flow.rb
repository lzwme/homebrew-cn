class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.220.1.tar.gz"
  sha256 "75fa080817bd7947372214606878b7bc42b69b890ac1465bcecc276c6d91ab27"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5126c69810babaaa44c380fbe826a0c6d13e7fa64e404f3eca19f45081790f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "556cb4eedf81274a2e05bd17e4c5faa2f4521c519bfb07493a80126a5a3127ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a60428e465ce5a499e9ea78898b22defb8ef0c8113a7ae193752d2b151b5a88"
    sha256 cellar: :any_skip_relocation, sonoma:         "94d8ce51325b6006bfa6cac36468856c7fe7e9df2429f4a116fd287c09471bd9"
    sha256 cellar: :any_skip_relocation, ventura:        "c96644360d1902f417deaaf287b6cfe98f84021bcf784821d3c4376d986ee6a3"
    sha256 cellar: :any_skip_relocation, monterey:       "4bb2c012ea0f81fad0eae97b45090ec9bc7cc195bd52a145c3b481ab77bd8931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f24c98653deab3e36013b6004ced93a4713053a665907aa8be99ed994a6dc9a"
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
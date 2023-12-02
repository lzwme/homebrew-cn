class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.223.2.tar.gz"
  sha256 "0363a7bde3f1ec20475b28802abb159f0ee280b993121f333b9ff3feb34c46db"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74cfe1986ebb794b3e05bd7f910c5ca6405cfa4755d271eaaab6fb615ac65306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f16951fc65fea143f25fed95943d7dba8a5040555dbb75ae2f8c1667b287147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04588f3420dffd26858d80661ba2a1fc7c875f5ae1d866aeb1256ec2c5fc540c"
    sha256 cellar: :any_skip_relocation, sonoma:         "496069894d4c4f0605202f78b7c5a2ca6681885e4d4259d7c0f1023a382c24bd"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6823c7f7dc5175159f1e536b7cafa415207b287076b9c72ac6741548e77d05"
    sha256 cellar: :any_skip_relocation, monterey:       "abb88e5fa19cee956857070c94efc0ed624edfbd7b9d0f8b8ba4ffa3cf14addd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f7b5ff76b96d6d7374b5019407692a4589dc63fb76752a29de5f033d51db62"
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
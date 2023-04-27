class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.205.0.tar.gz"
  sha256 "cda50f7c12d5330e145028af4975b61219b93b85d0b3f4207ced8a7a83528167"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3dadfb2347afc5c8ba890515709e4e62f7f958151a8e5ba8bc05c3d1588e697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52fa72e309d983a2155aee86f9a67e1fc346da3a7eea178533858be8254f2a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81a683dab89fdf5e217711410bad68d2e8c65d3f8a5c909bd07a301be1702b09"
    sha256 cellar: :any_skip_relocation, ventura:        "58d18b5a617d2ac2a9ee9cdc2c7735ff520dead18b3a68f82ed0023203eaf2ad"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe833130186ac8044c7657295d143e9c1bfe736f9d872a34bd827410e912b86"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9520752830a81366b8b331bd0896ce89c9cb4d4d74894f9b9e9ab3ac5fb29a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc206274e549adb37d20d80691fef8fa888561280341da207cb4c3c8cbbf7a02"
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
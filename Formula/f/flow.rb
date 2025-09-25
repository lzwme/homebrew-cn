class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.286.0.tar.gz"
  sha256 "3c6581d24e7ec55e0f1617a9792f00d8ce8a634df1146c2e50c994acc6805994"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa33a2b42935c47ca30d5206b7d37eab3ba64f5216b925374fef13aa5eb335a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da93a4112bb053ffffe7105b27c14fd4a7d4d8d5db9fec1896081ba5a182e471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb69bd369a7ecc7c4abb7b4f8dd390486168dd42494df76625f8d3e0cf5b4809"
    sha256 cellar: :any_skip_relocation, sonoma:        "28eb17088b5b58cc799d30d746f77e856726cf8e74be542b91e8c851f5aa2a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ce837d09b1c4b3dc1bb837796dc7627dbd944b14fab037487ca403145950b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cca92e622fc3d7039075d04f3fcbeca9a8e8bffd796f722224580d869cc7daf"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
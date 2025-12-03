class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.292.0.tar.gz"
  sha256 "dd125a58af0563ed7776498305a3e96a12166e4c04d2c16dc12929f224dc50a5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65c53079cf8b43daf7ebf40579adc7a0e522f32b56a9c2a5ab0804e56ccd73c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f08f90e9ee6e7f30236facdc6af9d30bf673fea4fcc848ed75e115b1133c765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "412e189a45f48555186a6541c9dbd72f1a06681594ac0f9b1ea769a1688f1fac"
    sha256 cellar: :any_skip_relocation, sonoma:        "6735e6e23355f88b81574e47f07bb340b3e5b5791a285af8c6ac7eb58dc59c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c68837545aa0521fd05abd4fe8757d202a503396015d8df88178447e02f95a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d770d2749e19b439653038d4d58ca88967c612fa5741081af59e9f5f67d391"
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
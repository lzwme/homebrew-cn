class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.319.0.tar.gz"
  sha256 "2d58d0c94a957c5f404baf551b344a3bcd96229550e95be2730e9c00cc17b275"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a0a66550e28e7c1b86a2f0c60b90fa0871afa06805028822daec37afa70941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7e4504ef61e9034132d439f564fa4ceb6e09a957f69754efc936d2c90999d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355778db2353fa27e9f0e62675aebbdc0f46d21948edbe1d8ab737c604b1a4ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9b796b19c59e5e8fc6af0b9d3767fa17f8f2adf62152926a54d63f63a546e3b"
    sha256 cellar: :any,                 arm64_linux:   "97c2686e62715f37035b79bfdf455e5457d904ed8969d50e73c85bb31e8421c5"
    sha256 cellar: :any,                 x86_64_linux:  "ebbf3aae66a7aa2a23ca5dc32a127362b6924d6c9f9026b2ed3580e4f14b026f"
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
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.294.0.tar.gz"
  sha256 "424b6dfe2a03009464eb9721306cd1b9928b3331d8dee82e728d344ca53609eb"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5aa78b9183b3baeccdac9a3b6204b935afeecd882d2bcb7fdc93fe66d3cd446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "418891129ba5f8ffb8728ec85a7b866de505b83f68cfe5ca7b7a530820a80fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb4632e6a37a51f3cb8602b606e490aef5a5bd5988dc282a73833550261e92d"
    sha256 cellar: :any_skip_relocation, sonoma:        "54e0ea245fd3e97b36a1c7842143bf422e5e6f6103d81e9f1c8068a6bf11ac13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f43971b9928d149b75d5c7b09f2e26a0559d660c8ba7ff190916f5f3de2a151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2865a2e0268f7f70cb20dd83f9d61be96c30d5d5a39936b0c0303123ac630a6c"
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
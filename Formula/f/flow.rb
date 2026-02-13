class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.301.0.tar.gz"
  sha256 "2b8c65ad754fa5e25802aa51f7c414f23595c98e88bdbf6235f42ded14ea891a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6d6ba15d947388081331d19e17fe5923b1404c2229bc2e2a97641a62c8189ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4a85b179e725dafab2362b4aebff61fd9463de19605498864e925bcd25781bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ce924e569cddca71adf035887562983bd232c7d66ab67198710500c92aee79"
    sha256 cellar: :any_skip_relocation, sonoma:        "1df887f26efac15ce2081fa9b979f1f85f66ec381528c70d23701d59fcfaf864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15d9a0936d3f73cbe5b10ba64bd530f8b693f383f13efabffd7d538d4ae490d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9ab5cace720a050c740baf88affe0c91d07c9e49a14efd1a3247ae7ceb7067"
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
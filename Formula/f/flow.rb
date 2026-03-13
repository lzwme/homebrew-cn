class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.305.0.tar.gz"
  sha256 "8aadfb6c143df03ffe342cd5e5ee4f3bfa1407f627a41acb63b5623e4fb1a0fa"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5786c33ba881ca3d9826f8d34c14797677e178a70127f4778434a1c6e000c36d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7585e53f436287ad814691d9bda49a9ccd25e0ba6cffc7e6e6518c701328d7b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e57534ac94dbc0d26b813c69d6c17d57017bf8bbf77b1ba0d54429a9981095"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe32eb7fc05e9178aa3438cd7e587596dad53f2d3cedea2f454e899afa2bbf6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1167265f003512b86d313aae7559acf49721ff5a8455da7a489bc0c101fe057d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361c89dfd2106b017d61e4764d7f16b1eef0b141d43b538d4f0ed5c2a6c6856e"
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
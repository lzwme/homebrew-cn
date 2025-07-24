class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.277.0.tar.gz"
  sha256 "7ce2f185fee57da933eade51df115073833729848006c6641e7dc6383e35d391"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ef0eeb7a534885037b1c55eb87370137df4791fb73adc77db9f36f6b8e4527f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59bafe6ca0f44e54c54ad3ee69709cc2050df40df4678845ee40f46dca5eac1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49abe7c8755a4a41db7b36b943b0d502fe1735fa963bc3de8bde217b38595964"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8aea56c94f35724057a988c9a457141a87394f1c5453295853b45d26ed3f2d4"
    sha256 cellar: :any_skip_relocation, ventura:       "3981f25fb59c57da364b2c95ce509de4c59bac922ce36e14dd281aa22381c2c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558941b4492224bd608ca4a9c774e3f0256715bb56586aa6e06bc81e85cb9d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e79d7d4ed99b03965eaced05629af5cbf37fbe8e8713bc2bf6f3b882f538e68"
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
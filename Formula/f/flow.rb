class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.222.0.tar.gz"
  sha256 "998c213ba9e4f76ebba328981f80285cd1493637cd7576ddcae03410c81949bb"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2fd4b2520c903322fb3e19e88698b9f01a6c0f18d6f04fea6446f0d6e6dea54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a17135d21c305bd66cea5bda1d883d0f16b4a23c353bbaa18e07949875070e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6225bd1f9481b1e29df79d4c58f9718a6e65ff24456ab8f135a2ae15221b1573"
    sha256 cellar: :any_skip_relocation, sonoma:         "527ca0660695fcf5c50cde311172d91e4f803aa853e7aa0b7c7b8d144f81b8f0"
    sha256 cellar: :any_skip_relocation, ventura:        "7b14b26183de2b258a7e81b5665fa966b560b14ec88c06873fd8b5fcb47ade37"
    sha256 cellar: :any_skip_relocation, monterey:       "f14e71aea5ef4930c7a019a9bf468964799d24de732da1d18078c4cce01550d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a9cdf358e6441c7181a10fe2e64f9f2a31d004c1c951d4538f3cfe753881de"
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
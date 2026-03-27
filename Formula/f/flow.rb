class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.307.0.tar.gz"
  sha256 "61620552a8f69fb2534bef337260a36d75d0b329232d676d5737e90ab00e7242"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f1fc0f9bea50c70cbce0b4c6bfd756463386c61df931d2cecc089d04897f75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8d7af7abce88e4a4d45f661020e7d6026fa961e50603e0934d4bd837b6154f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1708ad8c796fdca0230a746a9ba7b14b8f2a8f9287a48799c23756cd76d4fa53"
    sha256 cellar: :any_skip_relocation, sonoma:        "0366e9c49ed10adcc3b43cbeb4c41b4eef57d0337c7551c782442c935b6c3343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40896a9c26da48d2a04bb357e5aadfc469b26301463eb511bb86f3d1e325d1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e1e6b4227462bc3dbd74566c106462b3802e09a7d1f15d33b11f4e654fbe8d9"
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
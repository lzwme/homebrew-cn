class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.280.0.tar.gz"
  sha256 "bc7f7f19945f128f3560111387adf86825e097d401931f4e6126ea2dd361b1cf"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc892687f4a9ab89d1245b818f193f67d08fbef65ad82014480e16d6aff9991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f336989cf3928f77c3ba2ef1ae79ef29558bbdc0a7ba3abf88642362870597"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5c4dc188c182e35e5f9d11785d5b74d983c038f434b349156c869ee84001058"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be59bf5e2ce7efda1b4c7bdbfb043e467415a8f405c703f5737e5a4190810bc"
    sha256 cellar: :any_skip_relocation, ventura:       "18b844a40d5449ef61a7d81169600e8458213667787b12d76ed06833f44dc33c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "317e92c4b89be81b27e5d1401a98e6974e192bcdbbdbf115d0dea8ee0271d791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1470c7c653eb1c7ea9da8483dfbbf2bfd3accdbab7dd3a38c5790f5522d3a7a5"
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
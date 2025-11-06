class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.290.0.tar.gz"
  sha256 "7ce6cb4f531d465805f8ef7b84906a1f669a4d5ab8763120bd7e32b40923bc8a"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c719455483cf55934be273933cab528db07de3c18ff958a5ce599830ae357bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd89912069f9906e59a6effe373aef0e154bf09b1b210578b4fa3a50f9e73da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd34b08606d6f332a5a2b766107ead360ab5611c9cb9aa8e3c75a034c6ec8d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ce543c091614af4ad7563250ac1960aa534453634f5a58eb13e6f10fb185b69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5fbfa91c9561d492997d571b2755a099667a4711cba9888511c14056c7ea5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb498c52b81e8099d50def405a5899ae7ee747d799615076686156e1c6fb9824"
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
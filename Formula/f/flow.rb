class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.296.0.tar.gz"
  sha256 "047b51c5929644a8ec1640f0e1dd1f1a1329deb5c72ead9422302b6d2e938803"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1196ccc9a1075ce8c4fbcd546d0b9884bde88647efec31fa245f244a463cbbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a024323388aae830608f48af2d99c7c8f5cdbd5573ac6021f5baf2575476b333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa9102dc28e9912d8d1b7c5df438858a170a3e92c6aa0bd5681fb2bb387e2372"
    sha256 cellar: :any_skip_relocation, sonoma:        "764e55d6280def6b1c10138169075bc82612483f2dd8d00552e7758a0a03ef7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4033b7dc378a67e88715ada7201ebd3d18f6045fd60c869181808fd6356b5389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d4f93f2235047aa914facfafe1a4a46c0244ab98245b1125605089642a09512"
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
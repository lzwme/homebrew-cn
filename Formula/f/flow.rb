class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.318.0.tar.gz"
  sha256 "b84ff8ad316ff415a975a014587aacd07726a326de19520f31d1dfe10ebcf6ca"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027c97ad923b290b550d76f9ae07a3333b491bec1b00f0dbe6888bd29d2536a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5bf0334f31e5cbe5eb0be05aaf514de5f848874e8d6a8b40422b95102dafb7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411a70cb0b17e6acb964bd9183ed7de974025033269970b16aa2ec66a9e780db"
    sha256 cellar: :any_skip_relocation, sonoma:        "a749debd9b87af91c7fb5955eee9f272954770a93a30c51e14597c2b65a90a6e"
    sha256 cellar: :any,                 arm64_linux:   "ea2b20d7349b4f2dbe218e0a52dc7c78da953c5cd068e9120a3f1dbc631c4623"
    sha256 cellar: :any,                 x86_64_linux:  "626cd9a4832ca9260b0ac9d5fb82c463f9fde012edf566eed2a7801bf78f73b1"
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
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.295.0.tar.gz"
  sha256 "b230c7b5d0e1f2765ef099ff4eb6a286e2a2c43d8976190894c288c82b24251e"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a48bb937664a09b17e70dbebf65b34333badb25f7036af28ab4dca4a7792e4b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1fa712f44bb88d0741469ecdaa06dd969952d38362ee974eabb8860c8140d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcfa62ac51be6b990397f926c117127b81d4e5aca90cab8777053395a984098"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79cdaaf06e80f14409f4dd1fd94e0e7ad1034bd1d100fd799293e04c0399bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1829fa1222a9af8118fc8de0dd73c4c9db3c5c63b470a61bf7a412c09ff0f736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729948ef850dde699e6dfbee77b3bd7732ad5327605d8571c065b1303224f04a"
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
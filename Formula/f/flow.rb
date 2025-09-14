class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.281.0.tar.gz"
  sha256 "ce32b67898fa7cb702ddfe8b211182e47db58253a2cc6c9feefaeb3f67e1e748"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "736ee4f9355681c26e5818bd74cc1900e63d5e25852c387dabc10f1fea42d4ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "131e5e41485f40138c9b7f1555bdd05d5d67cd6f501ba88699be38a68d7df4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08197082e22609d0f562031f1cee8ca0b9ad5730414d3328e287376ab7b3abff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d9b59737a997cf267b3f05123497e8f845e0001accdb460e78c3ab0502d7af2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a814e5ec035c32e00546993c76208e90f7801d2147834771148815206fb391a"
    sha256 cellar: :any_skip_relocation, ventura:       "5403b1447bb11a1046dd784de2bf36f343844fa2f938c238d8036818e41e6d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c36256f1b60f68e9db3d0c7ff2c99e5c99cf83d34cd3f3547f6e41f55a68d59f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "890f85d67f73ed05f718861bba0376a364629e506ef5a35a4a634c952974b995"
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
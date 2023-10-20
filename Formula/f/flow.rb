class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.219.2.tar.gz"
  sha256 "c6d9abdf30fb6f115de5ed95b5d2e03dd7166b3a6063de9e49cd6ca9b8fbedc5"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7a0d31b0d801a0435438bc7c4c6ff577b5149a52cef3c9e7d62d11f3bb714dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b64977a6a40280730ff5745b4e43e2ed4aa2d97fed1513653da415a1aba529d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e6f665c624c4cb2ae505abcfe262015415598e0466d851104db11bfaa828031"
    sha256 cellar: :any_skip_relocation, sonoma:         "021a281c9c82bf2cc72afea18cca7b1f6115ee0893b3f5603509137a187573c0"
    sha256 cellar: :any_skip_relocation, ventura:        "148c90028a3fabb97dbee2cbb7939f98a7a61e6ce47632948527337b054c79c1"
    sha256 cellar: :any_skip_relocation, monterey:       "861d529756c6cdc192b10848a3d7086a205c44f3532e1c7790e1dfcad10de6a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1f98d65f465a5c1b460f7b507ea80c1d865cde3164db60db1b216a08596e6f"
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
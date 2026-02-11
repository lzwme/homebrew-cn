class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.300.0.tar.gz"
  sha256 "ff1c6697771e68e7109647be9018022085eda26a5589f37b18135dda37ee6d83"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d8dc52bbebcf5b1f881e8ca943788e35dc82a19d8f69f867a8b2b443b230c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcfc181f094a479e3b8181114c5ebc2a7d363cc9d7671aff1ee0823d71409376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4100ce103012229f5f5d6ca464234f0face3ac30b93d890b36376de186ce1864"
    sha256 cellar: :any_skip_relocation, sonoma:        "51d853d28ed1a0e9feaf2d94e3efde05d5a38a0b0477a115cf8a5a4d04b40942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "451a046d86cbca34440b73e346f820bed63d71c81b8d78f0893da3fa49a6e3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faf43e43d8bb231a19a28376be870c154eda6e95fbdfcfef0baa89b63eeb5c62"
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
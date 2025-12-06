class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.293.0.tar.gz"
  sha256 "48653d58607462c5c7d2f219f48d6b5c7207fe434ce8a850a3415af773dbd8ea"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0d34688ff70238a0a151359ba2e12bb04a4e2d65df728aa69dfd49f2c08ad94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bfb342a1b44e59adbd39737132b290f1d41f43ef83f98b217a1468704b3f415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd9a38239956ec398765401c7f9ce9bad080edfb95392139d2b6d2ae0dacd22e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2430273d443aba0c9f22696e727e630397ad457fe29ae1166d0ce5cc8553372e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175c06b96ab1ad3f56360ab11cadb1f767a5499b70d64d4335ff164d7bf5fde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7b7f704afa30d7e749d48f6938c2e5409c372942f1d9853e8c9e641deb1d791"
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
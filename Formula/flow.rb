class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.210.0.tar.gz"
  sha256 "a5b865f25bb882da1bf94dd023e565c8a7adca4cb949488ddcd0044ac8c54e1f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1e3d71e6855e5851203241d1b547ca9f26f76bc8ce3471b268c25203cd1c975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adf7d06fa00bfbf928d97f643a8db2ddb545ccfa3e253ab39a313f4f814da926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7a6fb8a1bad0a2ed0b593170ecabb46e2a0e13685bfd518139b64f728787dca"
    sha256 cellar: :any_skip_relocation, ventura:        "24d077b24b5b955a16b75e6a85545db964097041c509fcf05df5df0cb6f8a799"
    sha256 cellar: :any_skip_relocation, monterey:       "adeec52dfaca2e61204bbeaf652d059b821479714adef1141c957ffe5d8e5ad6"
    sha256 cellar: :any_skip_relocation, big_sur:        "50fee825bd2f95fc0e5866781f77a388c39c2b7e180cab203feb51c7d6935b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7be7a4a2f6f019aa5ef2fe0684a8b6d3efed9d14ee30bb9e030892361aa1742"
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
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.288.0.tar.gz"
  sha256 "406f7e83b61a6606be7218dc16775c2cea03265982527b24442e76c340f2e368"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e27653978ac0837de3ff99d290235934e803cd56e2da24365023b3e78fbb9a04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5744ac506214aa356934a9ae24d68f7fac4513ade3db3d2717bb0b3a0e66a0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2093923cf1d72fce07a67663c345a0fb1c520691593a5a82b8791e71e670a74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d61bf9f320c4af2734c4c780bacce0b0d8b1bf0c5ae90a652e8743138ad0b6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3923739f0f083d4251cdd63ad40e636a07ba103408c588910f9c9b198508db5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60857db5be8de6fe6637661d7e76340efe5800eb48b5714a1b28a751be959af3"
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
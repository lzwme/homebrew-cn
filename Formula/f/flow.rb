class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.279.0.tar.gz"
  sha256 "d711c4a623977ae18bc34b771503add35e549567b84182236e82b07d6c9d7691"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9097d441e14bf40953f36569c053c3cbc7044278439822570a06d31328437a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3bb23f36e24e16bcfb2e82ce94ca792e382b3dee7e7a7ccd2a5a76f6ab8424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c55d33e1fb5c3c41484fccd7b14d369ffd3917c8d242e54a54f081baefce3165"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0d43214bb3b519a43efa4f4eb100e3e437b8868049f82d8e30a06c7e110463"
    sha256 cellar: :any_skip_relocation, ventura:       "6225305da2c5a49956cead4ae575acadd27b95d35c2acc839188fc47772f2f24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7f0ce73b2926c6351e8ad60fd94a7867b563846f87b2989e37d709801642a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b45f36408c9885b4245ecdf4e7516d987b66f00b8b621b0949dbae21da4c641e"
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
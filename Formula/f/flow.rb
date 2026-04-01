class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.307.1.tar.gz"
  sha256 "bd3fbf7ff2bc1204e8429483d425b51d256060ac18616ad4f7bfac531b5a9854"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f18f94aaf84da67795df1139206ce10843d8d75e0f5e9a5bbf972765f20675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79cf266cb3641a5beeaf81109fdf67d781f866a1b1a8dba3cfdf8f03a8d44361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0f838f9ff614e8365cf20702c6b200ef9180db800b8ecb7cde44b0d627922f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ebd8ca46cb7e6caf95c9385d516efb9376cdeef6de4e7a9008ebab87caf359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eee4b81c6f323a1a1cd0f1703402ef6b27df3526f58e16c8c7c4c7596fa23287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e48960d1f44eec2c474b252e3161ed72852892df93748da3ec5fddb841a8df0c"
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
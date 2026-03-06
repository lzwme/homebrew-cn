class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.304.0.tar.gz"
  sha256 "a8fa3b08802fa4ac4f016103686ea8a2f57c11fee38678e533cb76f07bcccc1f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78502391fdada01bfdbea591acf2331ee108eb5a86b6c0b78631a76bbd4a532d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82dab62853f773f709740c646f27f18620621fc5fb8b599cd904475c062cf8a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c803f9beac5eb9fed95d2584318c9fd4e4e02cce4fa864944fa98b18ff04c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "43ce1fd3e7cecc44a886220074cb978876f6c089a5805f5ca987537dae2740ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d2b20382df02256897e2678836d79edf7268f58c840752a93d4c2a8c076bb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0356ac3608f7755b19e7e212a36981fa498628ccf71ad44d0fb77971fbb7f3b1"
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
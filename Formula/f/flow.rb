class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.219.4.tar.gz"
  sha256 "0ba6c32405b0c56cbf421ab4e9239cff7cec481c3bf17c73c1fae1269dfab089"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58776329299760e7c3830b9d0d7eeb4e4785f996d5ed85ea9416bf1482793adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb63002e985caf3f2f478c4d223dbc371c315ff88673b989bfb5c3ea6a398ce3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fea6d04942e5c41c58f82a6076c59d8d29909d2ca392c92d661122828a7de3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d80e58c1b0aff9b9c3f4231cd7db25ecd4348b7028ee1b31037d861310eb2dc2"
    sha256 cellar: :any_skip_relocation, ventura:        "b5e878cf77c849280e8320c1d224f794f1e76ff2c8d5d4c796e4b62c39e5f16a"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d6f041ba26571cb28e32cdd7e4455310861472ca10962f99cd90e2a1f949a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8867a6fb3aaf9b8e86e3ce12f413b816876f7e5f66e16a5f583e1481b2135c3"
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
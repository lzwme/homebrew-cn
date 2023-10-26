class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.219.5.tar.gz"
  sha256 "7ea538d9a578c9319958efceca2d373130209a83a8301e2ab06eb30e03745e82"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a25dc70830cfd303e375473e8a0b2a0d78915c7df3636335a46cfd2a3fd8f913"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da366561c790cd3b8bf1d6a8da125d8c975377ca42d8948ea4141c5529a08644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b89170c0510801129b1e3f344f6e419813ac40e9b1aa15e64772cd5521661d"
    sha256 cellar: :any_skip_relocation, sonoma:         "13ce81c7aecbe3dfb4687fbdf244ca2ccf53fe843207abd143548cf112aab578"
    sha256 cellar: :any_skip_relocation, ventura:        "1d27d56b7ab7e49c24fd1452425f1eb892a427dd9fc010c014c35c27bfad1588"
    sha256 cellar: :any_skip_relocation, monterey:       "8e3d9eecbf6d40c671a59d50bcc3d962fe31794f91585f3d7a8fba64ba7bdd91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf0ab747496140984c00732051af0152ef078b0b28d8f79b34ef0bb2b10a45a"
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
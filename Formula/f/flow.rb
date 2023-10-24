class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.219.3.tar.gz"
  sha256 "7b0be837496f7d82176b0639211b7928a30ae19cb6a733f5e689d104ae4336e1"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17dab58a76def301a1242906f9dfbbe986f0be22b58225c96801d2f9318e388e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24d2d6901459aa18a20979628afd0ac2163385941b1f0660ff698a80f8850047"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1401c912175c8e828d49e7acf7fecd5f2ec4efc9a6d4a41e454de95a19773769"
    sha256 cellar: :any_skip_relocation, sonoma:         "698a75d2f16b204deb7f1498ab6cd63f6b19ccea35e77e0fb516ae75fdeadb4a"
    sha256 cellar: :any_skip_relocation, ventura:        "254174ea9894ea97dad4ce4399d55ed08212edfc1e65f815b0a29d0739aaaf57"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c82468898e8e40d575aae2c2a5d97359bbb2e9d6a93d5d761aacfe5db3c523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb29690518b800abf8294cd607ca672fb35ee9faf1e489b7ed6901ecd541500"
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
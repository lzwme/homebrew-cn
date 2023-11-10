class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/refs/tags/v0.221.0.tar.gz"
  sha256 "ff7e7761e95406fc3f01158644252456428198969a09c3777835905110ac0c69"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1203bd451da6c970e8d99cae7a786c9527f11a413efed91cdfb86c2d4499cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c335bafb67c7ef2aff76c6ad0f9f2f40a6d9d29d2555018a6858451ae186fd68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131342d9a3fb8c2a37234a9afcd3090bf4af2705fb7dd5602fab4720dfcd3408"
    sha256 cellar: :any_skip_relocation, sonoma:         "b37ebc6d6bfaa63d32b8f326855ed950b603e5fa8de6ded0f40280b54457b7cd"
    sha256 cellar: :any_skip_relocation, ventura:        "e235d0ad2aeb84c8dac6329da9698b86b9382eef462e6090bbcd1146316bee27"
    sha256 cellar: :any_skip_relocation, monterey:       "f41b9e1099c3e0e40afbb669c0c436256010d989c58e730419062d5cff01e259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ad319b360509af3c9b851f93710a8bc563c0f2139e727e12fe7b7533bfddab"
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
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.203.0.tar.gz"
  sha256 "81d6aa5c1bccc85342c8934acfee4a5cf83420ff98db319a9fdb781bfc450548"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb449005316c41fe7769e3be3f16cd9da0ab92470acf7c68e70317ec19b6f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc0922ee56a33f33f153a88d94343c0f84236088009feb5287ce1648abf5a950"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3647f72a06cb5b67bd9e1c7469a47fc0f9b96893437ef0f277518ba167f1a412"
    sha256 cellar: :any_skip_relocation, ventura:        "6d580954b2017215f75247472a13f44d050d73d5a173c5c660a2392158df695a"
    sha256 cellar: :any_skip_relocation, monterey:       "3fafaa7269158645a4fe26b6679272dba1bcd2c9e244642db359df8dc33ed8d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ae50c4cf2bc865d80d0281ccd92eca2fddd9001ddda47755f4a90e413761ca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4ca18705c481555484393d530156452f2f09fcca47f7b3fc1b80381d96cb26"
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
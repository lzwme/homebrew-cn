class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.216.0.tar.gz"
  sha256 "c34c8af8aa27b5568026256ddfe16a3e246dbbfe6dbd16b90e1d10d5e91de2a9"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adc29a090862ab352726855a2f7fd4f7aa185b1c1cc242ea2f569d3c543e782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d1a55d76e4b49b846c76d903eef5acb9a24acbef9c6ef441109e988ad2576e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fff1e902defaa64cdf16e6ae9f458760b42025e4c382a5caf528b7c27171d7c5"
    sha256 cellar: :any_skip_relocation, ventura:        "26874ecda147b870d1da686d5d78a164ace83672a8802a04bfddcfad0145d7ae"
    sha256 cellar: :any_skip_relocation, monterey:       "5619654719fb151908d377680adffc36650dba538a5ef6282f0692ec72cf3217"
    sha256 cellar: :any_skip_relocation, big_sur:        "b555af36c4026b40549f8cbd2e5160e59d90412b3103c869ef94c4ec0f24ab05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f5ee9d0c70f5c70b7ecefab636ce375f52de49bcba7a3ee835e3a5903ad950"
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
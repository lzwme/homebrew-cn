class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.212.0.tar.gz"
  sha256 "86914896124b4566fa90d23495413dd71839747125871d21a35e4a17f27b3a4f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5aff8c76c97ed17328c442a9ce8ea1929d135b06f70cc4b9e571cc9afa46059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4583654a228943d40dec70ebbf8011680ab765efe5d613e9e97cd16e3441f5bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab62e7eb4e5ff603fbee6055209acebd2d7a2600e7cacf0aacfaf97187ef868c"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f75c64892b92fa57ff1df3c3ca7b6db79b4c1f6bb9acac52c4f4be677c4aec"
    sha256 cellar: :any_skip_relocation, monterey:       "a884659bbf1f48d2eb2b95259010dd2ffa9744a33e0fabf3fbee4c1a9053645b"
    sha256 cellar: :any_skip_relocation, big_sur:        "551431dd0383622c18c619a22db7eedaf8f0def5f4f20fc445f042b6319be12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636ca6da41efbc3ab4bd9659c284b6414a8db764b5d08b44ac9bebad4679ac9d"
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
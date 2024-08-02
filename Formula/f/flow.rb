class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.242.1.tar.gz"
  sha256 "149942c1ad7b0d5fa26391dc05915d4fc7b8666f94929b12565735f88a81a501"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1deb0ab00c75787b715002d890d00a4398980e75c3c4eacbda446a873f0b1549"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b05ca554f224528cf47e31fabbd771eed77a0b305ff628cb3c466842b8d13a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "998b2ba13261a8d2acd9bf85e9c9d5169ad626a35868183609f8aad8dcf34796"
    sha256 cellar: :any_skip_relocation, sonoma:         "903d4b38f53840e3da0208914e1ee43add2117e325ff9bb169e7bf330c6dc142"
    sha256 cellar: :any_skip_relocation, ventura:        "cebad9dc1f3375b57f7ac61ce0941b940394b1f4082034eeddeba5aa980b1fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "f2000277d259cbc38848dba9da909392d7097fdd6c61150bf05653d69133f03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e4dda8d8a65bd5886a22c86fc423a88e01ff34512b1f8bc87d4fbe4bfaba12"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system bin"flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.233.0.tar.gz"
  sha256 "20dd2ba4495a428ad309940e6799835e05aa795f4329709ab8ec4eab9f3b1f85"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f69dbc0ffe422cef750fde1f1583dd1f9e560e5c952cd8e217887478ee31db0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaa8b26a8eae5000eab9e512cdebadec0a2b6edaf0931a3c0cc4d592aa9b5573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57fa13aeebc3993dd107beabf5d1e3ab29a4263bce11cbae3171ea3bca3c040a"
    sha256 cellar: :any_skip_relocation, sonoma:         "93a12786f39121c0d35ece2a22e90b11259aa2cb233dc4366b0a1e63f38d6e90"
    sha256 cellar: :any_skip_relocation, ventura:        "d37cabdcfdbf8817361ce7642ce2543f9e3e18086b3c67accd0bc13a51413cd5"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d1fd7cfc75ee535fe2738f62440bf01ede7e7c738a09f2252c067549bb0910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04364e57093b23ac52bf1ea44f2b9905e44271fe558d0a239bc01c982f19cd9a"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end
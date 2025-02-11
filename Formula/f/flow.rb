class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.260.0.tar.gz"
  sha256 "93f675e36f2e8c9b33be1d4aaead77e0061a03c5415bda2df676d500b87b578a"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9ac49c77ef46b36c46b631d0e860687bb0aea0e6848d1a29227a2db77f6f864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ff0e036097a1d0bcad8cfdc1d533c8e6420f10f80f179a3c1b4a1e366a49ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba7ab4fc89e10941d5bae9ebade93986bf1c0d82a71377c6f2c62c7dce19084a"
    sha256 cellar: :any_skip_relocation, sonoma:        "feec95a43ede1fc361a021923eed2702b99d4808e3d339a0a7658ceffee5791c"
    sha256 cellar: :any_skip_relocation, ventura:       "a5059dc926803876dc0eafc7e5ddf1ef564963231e1cfd02586e952c3e2622ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6741d6f471e717e04063594cdcb4ea1a46f481b8fb1f5022b6d67cd29f1928a8"
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
    (testpath"test.js").write <<~JS
      * @flow *
      var x: string = 123;
    JS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end
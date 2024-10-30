class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.251.0.tar.gz"
  sha256 "3d5e0e522572ee1fda3a402131c95bcc731bcd8fa05eef77f5f35695b258584a"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b90bb6465bcf6ffe6fe046916a1421ff5d9645068981b87dfdc1b7526d542fa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff19682f478b7f686ccf34dd5bd22b6d04a3104b13e31ea888147c81e26eb182"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f33545a9ee5be73c9539e2dc50a16195e190368b97c1f9722cbf0131d1891cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc9a7e8a323db0a0e42f0478196b5dd42a4b320c6c19dbcb1018b1a541e74cab"
    sha256 cellar: :any_skip_relocation, ventura:       "eac59d3e61584b1177006f271ae5d529c8d96680cbf53958ea57f2a866151f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed838b986d2388d0603ab7114e8caf89868284024dcd02d614a47dc1c44f27ac"
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
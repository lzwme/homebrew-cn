class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.251.1.tar.gz"
  sha256 "07d0d439f2f0f339c0b8f7d680d85a47a1edbafecdea793dad399cc1d3baa107"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8989886630f8e33d7f2abbc53031580a49b2d168f30b95a4a2d249eb3bb97f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "698be02705f59bd5c94c95c00c036c287f3428657ec2e8ff961c4fd930463fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e377d8c57f1d61ff82038109180ec516969719f68a2e9d0f251b606c732e30f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85bde0bc0b6c5fb6913ec6f284b0cb1a73f631e5761435714c20dbb38cb41cd"
    sha256 cellar: :any_skip_relocation, ventura:       "afda482370089aca5e29ef9af88bce51d20fb9c1a0bbf230172d1675bdede2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45fc8b0b766483c55e514b8a5354e28055b350bcdba3279bb7494af3a7f9d9fc"
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
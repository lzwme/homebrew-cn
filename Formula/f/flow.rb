class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.248.0.tar.gz"
  sha256 "160f0d6f7e4d17a9d67507c287d4a424ec2d1e5c8db2a80877b758d6ec51537b"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e31a3815c500e5d4e304d65634b980ffdd2cdb0bf5b74f6b2c67c0a7e830f524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae4712687cfa0540bf1fb9217a2962df0589828066ccbfdbbd2f0718f3cc2a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96ceaefc632517181a515544d278727046781022660fc64191448fe86d97b885"
    sha256 cellar: :any_skip_relocation, sonoma:        "417f6e14d5c184a955aaf492caabf57bbdae11464efc687feefd63689396e4ca"
    sha256 cellar: :any_skip_relocation, ventura:       "6bb0db711f5c1a4e15bd865d951d5c8db94c5c55a24f41d49b1f2efcd1145048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd5e02b9a335a71e67cd41f4eec8ac1b255c37a71d5d7c634991bad1010a165"
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
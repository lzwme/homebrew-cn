class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.245.0.tar.gz"
  sha256 "5f0c530020a09ff3a3e8879301b21944711ebc9691b6c5be9ce83bf697d14c70"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33d8aed7f26a201e4bd4303c615f20ce38d2623433ba8352a50a22eb0123e343"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ac0cc44ec33aada01e422945c9ec342346b253a18085f289299b1ea0786490f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5b3b0d0761800dbf8b4191439c6b48935d443cbb6349a83ee1a4ed6a314c705"
    sha256 cellar: :any_skip_relocation, sonoma:         "d362ab706638dae07d762a4c4f624594d0a975ce1190b6f9c2207aa0976616a8"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb9ec92b6c83bf73fb9db77b107b5b4b703162a5aef72608b314e1c3004f34b"
    sha256 cellar: :any_skip_relocation, monterey:       "bf181b4c04a377b20a7acc55016a3f610f6126c1d4912cb4b9e13f5b7c781195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34df68c136f896fb48067233a2bbcd36869d97f5752c2b1dd283a70edd63d2d8"
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
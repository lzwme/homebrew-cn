class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.256.0.tar.gz"
  sha256 "79e4bc40856deedc2eea60bfb5f4b1bc4c6230893858531801cb5d83623e2abe"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3503c0616615c71b6f1d953498fcf78dadbada7f369bc0c8c439cd4134606b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd4015088c10620f434ef995185c619bc078e1549fe0ed123fd2a5d759fac96e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ed8f5c8e4209ba20dcc8824623c094f61003b81b06ad7bb96f695d851116d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9799738238e4bd02e680e4d77f4431c9efdc5a6129de789c86cbdd2a7c145368"
    sha256 cellar: :any_skip_relocation, ventura:       "b3ff60bb1c970c32f40f2933db0a147aa402fea3f3d0e9ce8571ea0e13408d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8de00e847180941819e283a68de6db7a52c5c56b01253cd419836d85552a2adf"
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
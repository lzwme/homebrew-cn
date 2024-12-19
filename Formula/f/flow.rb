class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.257.0.tar.gz"
  sha256 "9a96d9fee383c0973c9b080e7a8f88502a2183bc04eab318cad27a215fedfe5f"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41dc3132347a710913833b27a1b5bcfb97581fc2976017babbb3112a192a5144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc987cf050bacb3810e308e3181a38d9945a2d7fda61456a156f21ebe8e16a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "828de54760722b080460f7006557942eeffa7d32ab9fe545b898c0c49dfeacc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b24ff4c99ab1f55a232734dea971a1606fd4df56281729a7d125d5d89f6caf8"
    sha256 cellar: :any_skip_relocation, ventura:       "0bc799a3e67213005d7e1f4792b19250d2c837fc3ef8b2bfe10a719218f880e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5f7b5c94f4338c3e1a5681b99ade5d77d79a73376aaf0c4d6915675ac8bff1"
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
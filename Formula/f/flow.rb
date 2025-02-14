class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.261.1.tar.gz"
  sha256 "782aad815494b88f1c01e8fc16dd2613b548cb0320fc01df026b5d3066444037"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2472fdd932db23571b6453b1aa87dbc5607e5b4babb99c7876c73955a1b3f4a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4943051a6845d7c1e5c09eabbaf31964653873a58dee3f38ceff50cab706931a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c92e19656970f6282594915ac3f338fc8009e3256eaf5879f8c71c5a74ce2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9792cd6cd59366d749699d21a572ab38213ec94a392ff6365a873e380f540f8e"
    sha256 cellar: :any_skip_relocation, ventura:       "2c4faf1dd4ea0bdba9bf5adddb8829a499d11d6a238fcf344a6f638b007c3d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8860566a36759c8b8ca2a3fcca63a22e660037f91c4d982c857047e01353fe"
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
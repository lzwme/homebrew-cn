class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.262.0.tar.gz"
  sha256 "517c34c03d8557e9f2aeb8f42b98fd50cb1b2707e4fc3a9307aabe91de2236f3"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d17f7a9be43e164845e2231efab2f91152705963a3faf74c472d3c5cd5b541a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603f7c13e15b6fb74b07d41ffdcb66c6ddac578787e53c0c91aa15590ee7e308"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40db006987eb448c2185027f461ec0b3806d0302b7022712b371c21f9f00d6a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5960bd10635cc88f27b2d493877db8bb80d97e5cb66f2968389e96ddcdaddd"
    sha256 cellar: :any_skip_relocation, ventura:       "6a323d5eba1c341624c0381f8bd2ae8bca7d84e8f440a6023c1417837251ca32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6a0bf4c0fd4d6a22e2d3458faeb024acbbe342b6562c527e2f397ed3ca70f7"
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
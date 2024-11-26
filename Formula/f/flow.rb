class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.255.0.tar.gz"
  sha256 "3a6f8287e7d90406351e69afe12f62885e07ab23b327b034b52c95eb4ff57568"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38590058d8dc862ccf14e27aea8d5ed5a28117fb9fa5f471363295d43a097efb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee2eb085707f9739fe96e1b0e4744a1f20bf21c02ea66b9f1f5ea47ccb22f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97c9657a2520c992b8d48eedfc7b2e9931147e59eda65697c75a7a4d0b210e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbb30221f1d205a56ea64f3876c4190ff7ec296e9e56d92ea436d99446bf5387"
    sha256 cellar: :any_skip_relocation, ventura:       "1c177d8c9e57d48b49db750ebfcf2dbca995933e19dab640a17b936905a5d9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c6e0ecafe7f57e99801ae7b28dd5be1765ec196a9d184f966c030c1faa87fe"
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
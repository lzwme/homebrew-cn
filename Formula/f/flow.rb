class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.265.3.tar.gz"
  sha256 "ea856467e06ebb3c9bef010a99907ef9c48ee262234f8ac92afa2ecf87c26c35"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e1899106e4dbf1ddfa1a220948fa952980b9b9ea4658954201941a534f1d45a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdaac80f620ef8c488ad260ee001449c4ade045d40da92c8f087ce082905693b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86ff40acbbdfadd600e1f856d1af90e2c3647d041ed154dba8b5cca770f916fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "973de9402bab78479910cdcf86c0f44ed30dbff15e8d6f8995be3f1d1b2e3834"
    sha256 cellar: :any_skip_relocation, ventura:       "0bdeaf7b2771c23c71cb319ebc6bb0b6d5c832db81bc320a92388852c0d2f6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e21af432a8f78c4f35e2403c9009af222494302ede4471f529f8728fee1f6c"
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
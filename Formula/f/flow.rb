class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.265.0.tar.gz"
  sha256 "f8a70062dfe4451953970e575a036cdc1eb676b6a1510079273d04ba4e403586"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915927094800900a49de9cbd6019ce81e5615023a7a7390e309678a2c736326a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6558ba8d27c66cfa4ab26945cdbddd64cc0e6811356e2eb312291c3db1406093"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "313bb942315da69244cf28ddaca4b421165df648ca4f7b894279615315c7d9d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "413e886a09bab0fc3dce5833a77d9f2ddcb9b5ea77503a610030fcbe7d11381d"
    sha256 cellar: :any_skip_relocation, ventura:       "21f1deb26283793a544006a1657d275aff9cd6db4f4cb4534434d9293f324fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12fe23fe92a24b866180b847e14cff828084a5758f1cede4a18d59f936f9c03"
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
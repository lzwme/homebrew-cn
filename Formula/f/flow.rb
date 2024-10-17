class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.249.0.tar.gz"
  sha256 "7784098ca452dc3a381cfa3bc50421d46b716085d74d7e37ffd179c3506f7520"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f6449b8c64c54c191ad137ba17aed1ee2eb8177e779317154c032b51fe74c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890251409d34982d258f2d68ed4362ab757ec51c571a3a92e6d48262c29cef92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7397d30e867d3609aa59769b19d16774900b5148747de5f45bd61feaa5012a89"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe47b0907d6b76a2b8684660aefa62de57fe6176baa6f6204aa913b8944cd87c"
    sha256 cellar: :any_skip_relocation, ventura:       "254949b44f28c9463a3c6ad67bf38b09e576eae241caa8dfc36a6297b0720af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707ed781e61e4d2453832b7fc72c0faaab9394fcd4dd57f66f1c7b7cb54117e8"
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
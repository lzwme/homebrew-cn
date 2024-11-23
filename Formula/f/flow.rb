class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.254.2.tar.gz"
  sha256 "634016bc1d2e0e415437992ba8678275a5b66d0bf3f5432a7181035e6eff5097"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a6005b9e88787c91b184122f9e48c20918dabce98c400eba118b2b5511de29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66038e7e1797fbf9b411ee4c20b060d8ac4c230317224db8edeacaee900e44f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd6501fa03ad00e5031b971c05a083cc39efd38fc4ceccddaec875c2666ea282"
    sha256 cellar: :any_skip_relocation, sonoma:        "9221433b381dad818fed333e2a5fd5dc7cdf61a7d7662e05e9f9cb1f8c609732"
    sha256 cellar: :any_skip_relocation, ventura:       "71ca62b49c308be347c066bf3ccc253b07c88d503b120edc588d688239c41c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c24b1b97dafdbf58dbc74a0b252ed36507c58be9952bb8b7805fcc7d3ba5b53f"
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
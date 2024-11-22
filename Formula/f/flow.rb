class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.254.1.tar.gz"
  sha256 "a83fadea75e8ab71869b22550fec95f30fd567d14acd24f692e6cc190852dec5"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "321f34495c9d5025ffacdf48330b8938d04cf0184902ff05c5d6a7dee468f6c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4037e172eb010e49f09b67f4fcb7fa3c90739ea0b4bf44ae8f45729dd184f10c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0ee9aba710d6c5e7332d02da06be2514d814d72a8ced7e051eb9b1faaa1aca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7fdba6339e968cdf228ceefadfa4d2b862ad97f35f87b70d00aea721ce2ef88"
    sha256 cellar: :any_skip_relocation, ventura:       "2bf0025df58a0de694ccae9c40858d8dbd1980f952b8654406d8476804805864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c2e62e08ed55a76162e7e79402d70d5f9758afd55cc8d84848c2bc9b993529"
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
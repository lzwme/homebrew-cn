class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.210.2.tar.gz"
  sha256 "706b1ecda518b688b95d45bc123d9c1e3a4d02d3b3bd629d8a3fd94176163b7b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b266e503fb85bba248c465d9a4f51355c342a070b5135047ece72587ed262d5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4187b1d926209adb9851fafd6e6661480cf236c21d38bbafda075b654c852158"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1098cf5ae1bab025566af830f7e2f334dc23e73157d1255956ef189f9f6dbdd6"
    sha256 cellar: :any_skip_relocation, ventura:        "36e2bfc3e6b654d3cda28c32dbeb46eda6315deeebf20b79c3be888d7856d1cd"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c72bfbcc402b738025f8995123ac8edac4baf7777e6dbdac082bb678438c58"
    sha256 cellar: :any_skip_relocation, big_sur:        "58f475000844ba59b53e60a0a56f4162b292e64b63a69e6af9a517b7532d9316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d87ef1b355b43c12b2c454b3351a0edc2ad0b9861f9fc2389a8ab9df4f2620"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
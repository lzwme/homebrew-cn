class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.240.0.tar.gz"
  sha256 "19a58f5fe8066cbb6fb6b3acd35c512b9e71ef57d4a309071011d6fd792987bb"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d95d285456c469e066a5a72956d3934540d69df659c097a07430b37a0239684f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1816ceedafe584ef5a17d30bfbf9dddeaef832bdd302c591c6405bc1d0433e4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93227d90541b110dc907bd7354ddb1085d0d07c09a3ba9c8652ffa7fefdafa2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d874912f9836c1136b72a9efef10c6f0ed2154ee9754d4cc8099104b7f006e7b"
    sha256 cellar: :any_skip_relocation, ventura:        "e7d6ffd648bfcb120eddf9d31abc9620131173149345ebd262d577cf09076c14"
    sha256 cellar: :any_skip_relocation, monterey:       "1a8b5f2f37ba4bf180e6d65fa899ad4bd8543e7405c879b4309d9bff1031133b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9cc48505c4c0c63fcea31995ff0f94cce5eada94c80fe29fc12e128da68f961"
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
    system "#{bin}flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end
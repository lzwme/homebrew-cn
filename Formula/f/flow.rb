class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.239.1.tar.gz"
  sha256 "a3181034925c1fd1697db333219cf81b10eb8b169474b212e194d51bdaeace67"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a99151d03b4199bbe9b54eeb80904a5d8b71c9826658e341d90492ac3cae07a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baa20c36ac54b9928920ed8d88af27a9f6bf58f9d7922abca03815f3ff400e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c3ff9d7af7bbd2cc48021e8d40867382af644b178aa19e1d9c7326ae250d8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0ec45cde432cff9de9a5e7cbd6056e49f8f831237e65d0c66f9298f9f0a95db"
    sha256 cellar: :any_skip_relocation, ventura:        "39cab60582bab8f188cbe7f6d5127be2aba3d475e9205d17c2700db7a07f24be"
    sha256 cellar: :any_skip_relocation, monterey:       "a4eca9552f7e2a2c7f551f111fdbca1c5dfd26847cbcb2c03ddf9fb2dbc0ab21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a782c4f6d55731fd8bb3497716a2041d3d182bd59f415a574e9f968a6089d12"
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
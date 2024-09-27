class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.247.0.tar.gz"
  sha256 "f646ab8320590425dbca9cb608ff766b5b0082d653904821585e747919f52a43"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa924685fd300215da6adbe1a35a2f6679735c2b83dc39f5d8b473a6e001001a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfb350b91b8fd94f0db4d8b8de0b2d8692c91c3eb4b0fb43de2b68a8090085ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f71b9e42bc34df58a2ab82aac9d34cdf45c5b5b5b226b786ac6b88eb6b21f340"
    sha256 cellar: :any_skip_relocation, sonoma:        "f318e60ff62b57b4b6043cce16c4819bb5cf86db393dc54a04c5900e73e7bb8d"
    sha256 cellar: :any_skip_relocation, ventura:       "344dada96a19a76dfb3c094e5ca2c94ea9816c9dc5feabf77e37f84966fda09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf548703c2980eb8b14a90c04507f0e16e78b4c0a7f3ca07d5bbc1480be5b3fe"
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
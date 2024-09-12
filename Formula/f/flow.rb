class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.245.2.tar.gz"
  sha256 "f6c034a271dc3feece4f072937485b87c67224565db02be014387ee933704d43"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "839625ba9904a99d95a51fd61dd3175072b7adf964a7308fdacb054e16e3dc4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89a2551bf906c86865c16a46681e0c27c3118bce9dd6544ab4106b4ee4eba1e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9572f20ec33f4c869603fc702b36e865444b8fbff22fc5d796cfe398f9e448a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b830434f56e12a18375a86eee4fcd34ace6f38283dae470066beaff6e57b00"
    sha256 cellar: :any_skip_relocation, sonoma:         "24aec885443d8048388b9a784ec7af95b24f349327abf7687eccaea1d58cd3d3"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef86c442821add8d80f66fb6e089f477de8e88bc35c42409d4b3354a171d1c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f7ce9a8950519b66c24c9c7ed3af184280dde5fa7e8c7f1eeecf7f18d8b67ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d364ca6046ec347d617f571aa29751a6acae8effcb391d9529dd5a2329842dc4"
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
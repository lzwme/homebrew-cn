class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.238.2.tar.gz"
  sha256 "37fa3fb6435dc1b1deaf6a6cce35837d3679419b23bc68900fb5a4625f40b524"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "842151ffbec0778d0be4acd185ce3ac2b56c7cc68a38228c963288b689ac5fa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc16cf1de8993465e0cc04af003c8e517fe53ccccccc827c903f9446f8674bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cbffc07edb1dbc1462042647164dc879780255d320a1b03a70b65da7612a1a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "911388b43e3c1c77ccd75e704ae4307633850922549ebc88b25dfb270e9cadac"
    sha256 cellar: :any_skip_relocation, ventura:        "a022cf4998f4a2a3472cd9e4a8189c420d49c538f46370570e2b41f97c59bdab"
    sha256 cellar: :any_skip_relocation, monterey:       "d94c68da95cf87c03db9c2b00d735c14dbc8151f45273b640cbd7f17e7914987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f630cd3d10aeead1a844f325c5cacf4be4beef28181fa3c533f584e5151ec474"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

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
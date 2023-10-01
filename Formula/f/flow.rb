class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.217.2.tar.gz"
  sha256 "4bfd8e2483ea7b6c84d8e43e448103e4515d8ef514314bd13f6bd5db29469cba"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4d0946204c4818914e4a8eeae7a9a914e3250f42fe4ed812167fc6f1fa3de55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1da337348f20ae50458231038daaa389dfe6420c8048a67d02fdf3f4d88677be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3810ec53b19c5c7016e9dab8a1ccc65816425251ad4033a746a4f2b8a03e5831"
    sha256 cellar: :any_skip_relocation, sonoma:         "4330cc5379f17f98be849ccafb80a76c3ccfa42fe033b876cefe4ca44571bb74"
    sha256 cellar: :any_skip_relocation, ventura:        "d34aecb126112803c52cb5b745eedd16aa6fe50598ddb9d1b8c805d76bc706b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f1a07841eecab3ea29b7d986a5311265bc50b5648f9aa745da809e45eaf47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d654f7b6f75ffe4122bda36284e599f017a8b135f837a92dbcd22d9ea6887879"
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
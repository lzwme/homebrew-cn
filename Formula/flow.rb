class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://ghproxy.com/https://github.com/facebook/flow/archive/v0.205.1.tar.gz"
  sha256 "9af7a1750c7e4e7d9e568c6e238c036add93dee601ffc01ebaeba858eacda311"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca05944a8e3e31a329f08b789bfd9bd12e10d5866609d3002f7412c2aba26a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "608ec59504fad9df5da05e0137c3287c73ac1fbc01921d6505b15facb415d823"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7c5d2f912794b54d003362bf01a405406efdac1571bd73fe3039fd3b5741fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "4f4e295f5739d6147bb584a7e2d8352695f0c8260dbe35cf3ae155073dbf63ec"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ceebd0252ee2be3251cae9a9be8e14caa26f2b15ee507cbb0232327f1bd295"
    sha256 cellar: :any_skip_relocation, big_sur:        "775a5cac20f18d185f84bf1542a863bd526e32a43b716af2ed2be9975ee0cedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ee8387467719daed39b3a41234e6f8b64c556679fb763c1ca287d741169e38"
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
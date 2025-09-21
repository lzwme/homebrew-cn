class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.285.0.tar.gz"
  sha256 "8cb29f5a0d565ba2a0af5bacb583cd81a740f28e08ca45e60833a541e7302424"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4015221f4715833671dd55754f1308d2314fcfc4c192ab2ee5bb74f93d5e515c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b3468c5ce4f82bd6721cd89ad804ba2c1a862cd2e7963066ee952a7071c5586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb36be73d8672c56aa88b7bbdcdc371125e79e76e1edb26bcf61b492298fb986"
    sha256 cellar: :any_skip_relocation, sonoma:        "c81f4348135c144e787583560e24b80406e848c36ed3e9527c050591110e6a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d8a1d73ea3e58d85779da21173fd505520d8f3c6cbc0f4331bbfc3c2579f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc3d119453f36c413f2f295599f7f4dfea90b72b4d67a2adf0afb48a7817828"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
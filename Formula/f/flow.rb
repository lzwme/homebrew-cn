class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.306.1.tar.gz"
  sha256 "0333bc9855d6a6497a8c2173582c2b32a9c5019fb454c97d3853d48db47a37d2"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fe92c183ce4e051181f417fcbc03a1c5655d3656988c23d6b5b3aa67df0922c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6c533a41a1aa6f46584b56a64a97cc51cacf83f9c4f7ad6e2201333876a653b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a0381cb78852cdbbe4973008af1c28a050f648af92f3df15d306324e3ecf14"
    sha256 cellar: :any_skip_relocation, sonoma:        "04e6783b9f7497f3acba646e97719f694f13453d10fd6f106c5380e01cb624f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52a6acb7d3defbe061cf803b0a26e3c8be788ff047cbf7c704c5ab285a3946fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5200a17c54515081ed024af7a3d3d1fb0dba3c7a1db8d3d3ba36a9c8263ffcca"
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
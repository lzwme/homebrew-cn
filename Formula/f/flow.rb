class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.316.0.tar.gz"
  sha256 "99b98e55bb1ac63a1a4c36701d0ac9339aa9a0f97524554988756768bd0e6146"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98a20d01667cd3c13ed91d30eea2afe4fef7dd7c88456101ba882c26adc3d238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b88cd4b6b9c3f0c4c45302cabbd91878c6d4134eb784cfa7d27d4694cda24cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac01689eff8e4cf59077fc546c48e9f51ec55dc8d771c35f8217d9e21e8e5aee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c85a69bc0cf9eab94e11cbb5f5013cb50277d0db3f7d0fb41ca518cb572eb0"
    sha256 cellar: :any,                 arm64_linux:   "0e222cdb31322729dc17b6e302550ff0a33946c56d483a281901061a1a24f9b4"
    sha256 cellar: :any,                 x86_64_linux:  "26cf55e5b406c1fe7ab57ef9108cd2a9467bb4b89d6188eafbbba20a4c1c0692"
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
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.303.0.tar.gz"
  sha256 "eaf178a72decbfe4c2a22c4a3afc3f901dce39a573c52a0b84bc72005d06e0e4"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee20ebb87e89ea688255686a2d25f2c982103aeeefd379ae4a7e8a2db1bae4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24788e5d5318d4c06bb1b5346aa0660f3f408a5727efca9959037ff729f35001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbe824317472623a55eaefd4eeaa554594814885361fef1afd671ff04ea86593"
    sha256 cellar: :any_skip_relocation, sonoma:        "33db9997df1d0a0f69d798a446d32b50ac201fa9b8b5299a1aca6f53d4193afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "662693e557a88dfdb6c80d0fff406af332ee78eb262041dfdede422b4d7bdc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "534d78eeee412d70144572803f687dc79d63681cdf79dc0f69ee498d35ae068d"
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
class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.333.0.tar.gz"
  sha256 "a66604c86fb9e491d81db8fbff849b45dcfd82cf2c04292fab71108ad7eb58ff"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "659757c6ab5a7c4b9cc80d954cfd483164e7c4a542af637edab643856bc0ca54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "949a6aff7feec988daee040a221bf3212cc5b57e733bcb8f5a76fb8c19842228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f50ba9b6d617b4da6a5509ab45171be22b82d63f501314006f2627832a966f84"
    sha256 cellar: :any,                 arm64_linux:       "267f3f137c380f1d5069594e3d7b1d2654f2de87842e109f06d24201dda0a936"
    sha256 cellar: :any,                 x86_64_linux:      "025b725a00cea549337463784749cba73cac43398295bf8ad8017eaf0acc239a"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", "flow-control", because: "both install `flow` binaries"

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args(path: "rust_port/crates/flow_cli")

    # Resulting binary name is `flow_cli` but in the release artifacts it is renamed to `flow`
    # https://github.com/facebook/flow/blob/main/.github/workflows/build_and_test.yml
    mv bin/"flow_cli", bin/"flow"

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
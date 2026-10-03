class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.334.0.tar.gz"
  sha256 "dfdf3296e66095fd87a0969851c469bb177591113962df8aa6e1f5a1feccf58f"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2a6868f125593226cd0b0d2c31b2bfb27488adf88d502d8d09c237156babdb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d87c9d2dd1ad7a3126aa5c6018e79fdca6c14e1382b58df40f79cc6093fe8ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86a60e0e3ee7f77801e10033c46b4cc0c301d2be045b22149f2625d86cdff511"
    sha256 cellar: :any,                 arm64_linux:       "30cf76f4251480994173197d31f8b262768c399556569ae01309a9c22551d5b0"
    sha256 cellar: :any,                 x86_64_linux:      "6f682c6baed3cd420d841650a1b31b374b92a9f3e4190fc233cdc5cbfaf791a0"
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
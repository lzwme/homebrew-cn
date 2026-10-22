class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.337.0.tar.gz"
  sha256 "d7e0783e1cfbc5b04a04ccdc5e01624fe428e0062c715ce05dfc4116475d020c"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b90044637eda9375843888a5011a4164a4ce7841de004d3bd3c67ef940521807"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3bbbf3131b7728029254bdcfd0935a664346527468c525a06862474e2fb0ce3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a96f46b3b88444b9dcf5f22cd392dbc3e0f173cfc3b3a24b4bcb9c47f91e3114"
    sha256 cellar: :any,                 arm64_linux:       "157f9c75922c6113151fca0157e3c5c2a659b67b745bc0b94bae7a90588e24fe"
    sha256 cellar: :any,                 x86_64_linux:      "690e10d876f00fad46410e770cbfef3f131b4bf472a5f128c700f2359f782629"
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
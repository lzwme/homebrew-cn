class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.335.0.tar.gz"
  sha256 "a0852ee6d0521bf9de0336baee9af235c628eac2291ae852639708d68bd76347"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4adaf59c778a33f1daa9d07b23c47da3b3e893c7191a7812f1c4a4c755713344"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1dcc37d50564e8330e746dcafdd155bd6d3fffa15d2b9f5ec47b445c53e60f95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "966d21879aae60e3c6799b911f2b5b857ec0c217cc6665652707ee277eba8971"
    sha256 cellar: :any,                 arm64_linux:       "363021df5bb5a817e1d745f397f0298e0b0086819e6ac2962b2ae4de675bdbfe"
    sha256 cellar: :any,                 x86_64_linux:      "d65fd9214d4254c9809f01881fe5d022924f80a33ff2ad9b6b543fa9ba719c11"
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
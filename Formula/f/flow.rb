class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.325.0.tar.gz"
  sha256 "175c82b657626fbe531117d1639027eaee3d7dcd41ef6aa2ecd099021fdba787"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19965d405dc857214840b8efa3b5d1fc0e68619f1c7670914e1156c71b1c4f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "906f420db8d97130fa4e63ca5a5ff6f19fa1a595edaaefd1a3f6a7e22179fda7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6244f3062e42ea6475134ed6a2a48c745cafc1608869b6c6321a2c979424a81"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4c6ef32e8db94d76aae4830762a43d4199889a5b4172a2e1d3b3fbeaa6f4771"
    sha256 cellar: :any,                 arm64_linux:   "4709873647654cb24d3e10f0beaca20b8602214913acd0e7d1365adb1d675d04"
    sha256 cellar: :any,                 x86_64_linux:  "41c10361b8278429136892df507ef56776fed330058eb0fbb3bfddb9666ecf81"
  end

  depends_on "rust" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

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
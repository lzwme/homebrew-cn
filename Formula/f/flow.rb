class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.330.0.tar.gz"
  sha256 "15704382b65334bda77350dcdc7dbccaaf3c7978ba2bae535ab50d4382690ed9"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "130033be3fc48329e87d8d57203a7350bdaa8d185db6f76dab00e7ab32f8b368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0543fa53bae77170ddf28e9680f6d16f354dd2042cd18eba186921a21ddf5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "812c693dd36fb5d1036065193c71d03fc931502c9fec1be98232eb4f85213060"
    sha256 cellar: :any,                 arm64_linux:   "e7347f3f30f57b4e70ccee672dc816006bc6ed375f4d77f79d80a0eeb50573fc"
    sha256 cellar: :any,                 x86_64_linux:  "68701510d3694e7c3e6f9e28143fc054d939c3797623aa1ff0d1e08180bbed13"
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
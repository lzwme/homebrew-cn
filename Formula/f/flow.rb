class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://ghfast.top/https://github.com/facebook/flow/archive/refs/tags/v0.324.0.tar.gz"
  sha256 "9218bfde4721fb103ea7ace8c92b2e297484f2a67694b1489cccee286bfef728"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a562213498c1d831b26996ba22a1b0e1d88103bcb22a96bb138e6c21eef0b2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb92b8c4262523a6e5374c4cb1bdf64ff1ca34680fb5a8c86049d72c8d8016e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a014f1ec90759eeeb000707aee4e102295c014e184889b7ceccf580433247b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f1aeeaaefe8c10a994856b957a54c2aa3eae305880465910f4ae9d8397d463"
    sha256 cellar: :any,                 arm64_linux:   "5ef1c0e027440d9bdc71cb669617a67c4f7bb981251d363ea04a205f5d3c4cbd"
    sha256 cellar: :any,                 x86_64_linux:  "51056e4abec358054b3673246b5c3fd3b276e3144efaa52c4d4e2d8b73159f44"
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
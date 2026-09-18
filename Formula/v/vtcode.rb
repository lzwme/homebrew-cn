class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.163.0.crate"
  sha256 "97f8df465303d6474b8c807a9ecbe7b5fbe6d6c3308b3e58a31718358ccedbb2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8dd447df9cdb6e6e7d3030735375035116422f2bd07214a3b0b909016be349e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d34908780130213fdf5dc6a47d475338564bd41913c0b9fdd0b8b8cd2060b17f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65031118a1a7fe6336795ac1d2d1afe7fb55f8e95e75edcf38f21e05e9921930"
    sha256 cellar: :any,                 arm64_linux:       "8bff34565f35793aad3db102bd9b7b7f39adb6fa72dd0c4c053a94e84d680df3"
    sha256 cellar: :any,                 x86_64_linux:      "fb90b65bed8c31cc90447fa808ca3385aae806c43ad6b2a0d7ec1bea5aa70c84"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
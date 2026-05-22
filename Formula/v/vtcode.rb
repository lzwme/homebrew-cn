class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.107.0.crate"
  sha256 "59f293229c508af703417f6de39e7018c4a593b889f762c478db146ff35723a3"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed344f4a87fd2b2cb736d7e2ab9d21f7092ba8bd7bb5075196cdd59d3b0760f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1b0f8ded339830f86a12da6f1e477855346438e51714c6b4ad78bb564abfb3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aff47b21ce0880677765b253ebb7aaf8ffb03034f16efb86b086f0d9f87689f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1afa96cc2dd3c6e603734b6b07132612ff3e00d6a85b0b04005ba7ea431f37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6220202f55711f1edb2cf6125902dc1e5f91ce4a13bd713cd458822e99468b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca6f05a0ca751a4ab37c8f1d4c4a896d5f308979a7f07bf8a7e9738961ba4b2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
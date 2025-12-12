class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.16.crate"
  sha256 "5d1f383be63e6dc9ee6e0d940a90fdb43ace70e475281b4da52b9dcc09ae81b2"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5c6d04b89095434ae6073e599403d504ab05ab27335d1e0352a4a1ec9aa1259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98367ef6450d81696c5ad9f865c1c5d509a1d8d7d78ab6d0fd14c7082e5715f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f74071617b811f3cdfe8deefa8343d4a5c12698c3924077687f0bf886be80203"
    sha256 cellar: :any_skip_relocation, sonoma:        "15b29c2ee99653f0b229936248f57ff7c1e26d847813dd38ca9c077e3de5f5c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ea55641d7b936987f621cb3f5fbe0b00d028dee418719b75361c243dc41881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a2b2ed2846aa2fa3f50aee313c71a22db6546c37d1b5f462577bad3f4f3a5fc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
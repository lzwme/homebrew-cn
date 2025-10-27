class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.35.3.crate"
  sha256 "5b255dd20b407ed5eb73ee0ef863fe247c5429141387c0468342af011a8950f0"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "140c5eeadc0970f8a630f8a1a0473cd956ca4bc818575599188d49475d1bba7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8c1a7fb8278c1c66546f864d32d40b9f80ec39931786b020112887d727987f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b0f5a5e43244c86abc2df9c68460c129acb56a0462f49600054cc71ea01a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1aee9d5129ac7f965e70fb2ca2a91e82a0f351dbbc71dad75fc1073a0a9f7ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0ef935aba9bf757c557f38565ac55dcc5ff414fb61e3f468fd815d9762e0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec5f489563c72ac59004c2c414363fcd930b068038e4448339d9e4d505311b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://ghfast.top/https://github.com/lance0/ttl/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "e3e2f88707f0ce22a329a91f2f2a2e2f33a5468470fe076c15357328156300a5"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "775a351601db9b90f04222ec4760f690423d637e45f724d73a2c28b28199440b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b755e75875497b4c9f12798e2996e153797e67e78db7bbe1040cc155d9d3e8e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2df41b3c46d3ffc2741dd0f37c45dade62563ac888af459728d3140c652e42a"
    sha256 cellar: :any,                 arm64_linux:       "70dee439a7240cd1df45d883912bb35acfb9f024cab918519e904e17c4e5ffd1"
    sha256 cellar: :any,                 x86_64_linux:      "eb398b8637e47089437f4eff09650f6857ea802173b763ff80997bd064d67d51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end
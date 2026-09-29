class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "6f68cdba3b8880a04fa9184e3a7049d778be5987a49857a76fb4a69a708f29c5"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a237cb31a59604ce41ed6452179e603a467cbc3f828e8af8313beab6371113b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee9553827d3baacfef36edfa2810ad2a4991eb7f6e2a8e29587c8ed96a9cfbed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a38075cd0547c4f37db7765db7d269e654a44cb67729cf82408da0e971817ebd"
    sha256 cellar: :any,                 arm64_linux:       "4936ba48b7fe2707437bccb0bb57d8f63eee050d1e29e801abde262aaad27620"
    sha256 cellar: :any,                 x86_64_linux:      "55286c319c39393ea2866a71a7d5e821143677ca836cab4a2ef9340545eaedd4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
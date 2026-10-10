class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "4b375ed0d042a96dd9d2f7802d924cee6fd6f368fbb2399bb93d0c4584d694a9"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8f97e083ee9caa8c6b008c5e6993a01e4f67fcdde0cc3845de12a025ca12a30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f61198c4cf501e0b9c6e36a7c952ad7171db62e51076982b234d22a98725509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ae6ce03b4b42ad5f97303316e374550960b421ce50ed49b275334b6537453fe"
    sha256 cellar: :any,                 arm64_linux:       "d9a7f51fc1523c776937e8cccdcd7e9f6ecb1acf59a7d24ec8b2310a946685e3"
    sha256 cellar: :any,                 x86_64_linux:      "6a8f23abfa32ca558ba546d071022c54add26f65516430451e068bf496bb5783"
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
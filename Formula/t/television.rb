class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.11.8.tar.gz"
  sha256 "5f7bfdc27ea7adb1ee1335d86e0d4eae9454481b88df20e8984a1e3a455e0a09"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3385680a3ea44bcadceeff397dc57095785e1637a156034841f743a4faa1e206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc492649603060a6e18395e28dfe1ebf7f44d929203ac68ad06889986cf6968f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfbe980da4d5eecef799dc2b04e16b37ffa31c4512f92ed23f102c2823bafb15"
    sha256 cellar: :any_skip_relocation, sonoma:        "caba808c9bd26519c0570167f3f47d631e2dc82462999af4b80b1319a697d1a6"
    sha256 cellar: :any_skip_relocation, ventura:       "c63f075e9f58881ac3cc96709cc62713222f0171a9245dcab5645aaab7f83bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25046de7f855e15e2f785b039d5db9cac894230ab40721688f1b27726ba913e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f813bd6aa083accc847d211ee65a9ce5671d98081979e040ae82edc2aeb3cc40"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "mantv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end
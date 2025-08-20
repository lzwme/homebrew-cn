class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "46dbc1055eb7b2bdcc85492a854858290bab44a67355c04c992ac0c436261452"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2303b8ff74c8797de93f7d2aed21b61e9aa04d97ccf99243899924ba4dedc16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2303b8ff74c8797de93f7d2aed21b61e9aa04d97ccf99243899924ba4dedc16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2303b8ff74c8797de93f7d2aed21b61e9aa04d97ccf99243899924ba4dedc16"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcad94400f9b4322ccad20ce0d6e209c6192e2587f50914389457bd0ee51c6a1"
    sha256 cellar: :any_skip_relocation, ventura:       "dcad94400f9b4322ccad20ce0d6e209c6192e2587f50914389457bd0ee51c6a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a9871b0549e486a562e2e1ff84c87522a7a9523e8a03cbc8cf99b63b76fbda"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "\"method\":\"listblockedips\"", shell_output("#{bin}/nak relay listblockedips")
  end
end
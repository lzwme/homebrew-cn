class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "0f86d7ce10414e6648cf3cadfd616582184b7c28e944398de6e71bd0334c476f"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f98d5d7e2568a2862a9b06b9eceb8a059ddefb35d4aa027c9991a580831f59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f98d5d7e2568a2862a9b06b9eceb8a059ddefb35d4aa027c9991a580831f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44f98d5d7e2568a2862a9b06b9eceb8a059ddefb35d4aa027c9991a580831f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b6ff79307faadd827ddbe809c56de85be8affa8ab0834f7f756631aeab786c"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b6ff79307faadd827ddbe809c56de85be8affa8ab0834f7f756631aeab786c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "026512c31ef9edcc2f076a6e960b53b8396d5546ab197eef549b83421d077f5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output("#{bin}/nak relay listblockedips 2>&1")
  end
end
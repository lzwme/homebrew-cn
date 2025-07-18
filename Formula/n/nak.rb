class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "87c101aa183fc6872158b83a8b35c2f695f3d5cf2b0247e69b5f7e5f8ce6648b"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6108c65d95de1667767cb21ca3d032476f7c1c90a79995f46898487e473660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af6108c65d95de1667767cb21ca3d032476f7c1c90a79995f46898487e473660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af6108c65d95de1667767cb21ca3d032476f7c1c90a79995f46898487e473660"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ffae77e074236162682a1451bd3ffead32797cca77578bb66ac9bb6dc10a40b"
    sha256 cellar: :any_skip_relocation, ventura:       "8ffae77e074236162682a1451bd3ffead32797cca77578bb66ac9bb6dc10a40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1984e1a8d448a9f6a8e819cdacbaa55bdb34c8aa0e24dbdb1222f74789ad32d"
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
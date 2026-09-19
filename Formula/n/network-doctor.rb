class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.3.tar.gz"
  sha256 "6df7e95267e095b5e2bcab7c96a6029b954bea064b1f9da3ee2e60c308efaf59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e3e3f9f754628b2915e261dbf7917d5a07de436ae0b1152057dc8211a3cb44a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e3e3f9f754628b2915e261dbf7917d5a07de436ae0b1152057dc8211a3cb44a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e3e3f9f754628b2915e261dbf7917d5a07de436ae0b1152057dc8211a3cb44a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ace538c375d4047745fd48da03229e77b6754dce38ecc81db0392318c74f7c6"
    sha256 cellar: :any,                 x86_64_linux:      "197f23753cd2107353d609701706de48a91ba287a7a83a51245a61b8c0acb834"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "b66ff38a68e188ee46d12d292f6f8d7e70ce0e49acf65a1d4c80ceec423f77ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1a5706ad83f743ea20a9845aa598158649c11fc4ba746764116e66094c9999e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1a5706ad83f743ea20a9845aa598158649c11fc4ba746764116e66094c9999e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1a5706ad83f743ea20a9845aa598158649c11fc4ba746764116e66094c9999e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af53830b2f08cc9b14cb2b9490580741e8c75c96109fd4ad73adaceeee2e2e94"
    sha256 cellar: :any,                 x86_64_linux:      "032dcf80cb6205f17fd4119518e266423e0dd8f9b729d57e1379c43d1846c2bf"
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
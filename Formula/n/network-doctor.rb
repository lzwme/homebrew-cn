class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "74a79c388920bd8b5ff5263bec0226daa587e19a396fd2b149a4aa8ba6303383"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66e8966895247c399b130cdfef39a8249bad48ff400b552591038c0856605ce8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66e8966895247c399b130cdfef39a8249bad48ff400b552591038c0856605ce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66e8966895247c399b130cdfef39a8249bad48ff400b552591038c0856605ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f66c77a3f5adbd4aa66a1879f7cb9f3564a6ec54e6b2ea55132a127106422f9"
    sha256 cellar: :any,                 x86_64_linux:      "c31e534e2567e1e1477eabbc0a50c3a4fd91b734106e046db1e3034b64d23a30"
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
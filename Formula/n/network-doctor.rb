class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.8.tar.gz"
  sha256 "73c93b26e92f6831d971654020f225f21e97ba2047194af28e609e71b293b17a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21a97c69b17597038a22131ba75d3f12cf39047346c8e03d23e2a4ac5d19224c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21a97c69b17597038a22131ba75d3f12cf39047346c8e03d23e2a4ac5d19224c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21a97c69b17597038a22131ba75d3f12cf39047346c8e03d23e2a4ac5d19224c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61620b71a96850c8181aff80823003f05f616d021c09fb9cfdc7e6342a2d0b7d"
    sha256 cellar: :any,                 x86_64_linux:      "79285294c4efae2fb2fba06455a90322a5acfb92d4fe35f4b812aeb0dc4ab88d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
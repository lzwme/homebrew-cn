class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.17.9.tar.gz"
  sha256 "24959396bae4ca12fbb37ce7fa38021f1f98149ec9187b2d0038a57242b7d8c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a703defbbd27551ccce6e9e77a62fc9722de29a1b9c43325b94372f3669039f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a703defbbd27551ccce6e9e77a62fc9722de29a1b9c43325b94372f3669039f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a703defbbd27551ccce6e9e77a62fc9722de29a1b9c43325b94372f3669039f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23c051229843b44a78cb7b045d6390426a9a90004ddacc9dec23099693e52648"
    sha256 cellar: :any,                 x86_64_linux:      "53691b4a822d7cf8014757695ef335fbf5bf7e2c58c28ed2372ed92c48ecfe54"
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
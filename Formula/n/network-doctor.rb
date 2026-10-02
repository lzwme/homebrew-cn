class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "9e020c5371c373cdd2377962d98cfa3367547856d797f8926f197566f512171e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca88da4f1b65076fea4afb43eff6e4a653c4d85698634d55828004159b301e1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca88da4f1b65076fea4afb43eff6e4a653c4d85698634d55828004159b301e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca88da4f1b65076fea4afb43eff6e4a653c4d85698634d55828004159b301e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8735482679a58714204d478aeffca6c828b548bb94fd73f02fa3999d1ec8bf07"
    sha256 cellar: :any,                 x86_64_linux:      "8879a965e8a0292c31f6f990a34e0d38b96f014883d5d6f4f51162bdaa530bd5"
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
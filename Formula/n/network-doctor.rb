class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "56d28e2c252b607e51b841d63f3bca655ac1d8ce4235e6f602e594014cc93031"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ffceb2b9e03c16d51974d81696ce00a7693105305a6c03700b02f171196f9c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ffceb2b9e03c16d51974d81696ce00a7693105305a6c03700b02f171196f9c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ffceb2b9e03c16d51974d81696ce00a7693105305a6c03700b02f171196f9c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4860c56399b8736619b8bed885dced0d29a56b3c64fc716326d417ded14f9aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d12ecc8b17f7a492b1d01b8e40c35a92723644465d614fc36a20c63eb3ff65f"
    sha256 cellar: :any,                 x86_64_linux:  "17ae3e6e02813b2004c629e323d35c0c1b27cc1ef38e3c1bb243fc5b2714b2a6"
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
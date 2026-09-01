class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "39d24235a5774783ed969b520f503c538afe0d44a288b7398edbeaf9f69ea4a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4337048d02e830f522914cf61fedbd13d799ccf65e90f386236f5fb4ecfd61fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4337048d02e830f522914cf61fedbd13d799ccf65e90f386236f5fb4ecfd61fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4337048d02e830f522914cf61fedbd13d799ccf65e90f386236f5fb4ecfd61fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a989b305765bfd3da34a3702564b3bd3d86dcaa2a1e60a52a1a8f037813774bf"
    sha256 cellar: :any,                 x86_64_linux:  "2dfd40fbde2d3a0f1a6532e0e0b0a64298713711ee2b67da604d223b45fd9f11"
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
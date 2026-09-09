class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.4.tar.gz"
  sha256 "a94c3c485fff88ea1447d33525d85ec2a696f4cdc3462d7e5d09522c5f9c8f92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "089e8378f94811f3e82263857e6b86fe30543783a1183b93feba80fd420eb49c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089e8378f94811f3e82263857e6b86fe30543783a1183b93feba80fd420eb49c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "089e8378f94811f3e82263857e6b86fe30543783a1183b93feba80fd420eb49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a648a434887c7198f403a29a9a56cfe1add1df5034d85607c60c14573edc5b5c"
    sha256 cellar: :any,                 x86_64_linux:  "cb5fe349c9120de51688e3f3d583f7340a2aed8fb223b3c8e3fd914381cb0cce"
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
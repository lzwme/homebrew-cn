class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "48f06043eada6157cba4ec3bfcdbb5b3dd935409e3ed4a501ee1ede6a00cad49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9e798e85a3195a376d92877d1ed0c544848f66ce3764e4bba2b0f687ebf2f8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9e798e85a3195a376d92877d1ed0c544848f66ce3764e4bba2b0f687ebf2f8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9e798e85a3195a376d92877d1ed0c544848f66ce3764e4bba2b0f687ebf2f8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "061b9645ffd3820e5259780733f253ce74e03ac3dcaacc0399b49929b3c9125d"
    sha256 cellar: :any,                 x86_64_linux:      "54f3823790e48b7e1d98207c6c8a20a19aac3647102d476e5c465371cead89c6"
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
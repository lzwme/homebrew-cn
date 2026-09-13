class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.7.tar.gz"
  sha256 "c8b99f0fafd9c30e4b826f06fa5fcc2216cc9f83504b3fe9d09faf65ca56b64f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "361704a2063297587e03246346bf24451f5c5e6145331368edfa3c48616d6915"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "361704a2063297587e03246346bf24451f5c5e6145331368edfa3c48616d6915"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "361704a2063297587e03246346bf24451f5c5e6145331368edfa3c48616d6915"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ccdcdc24518e5c1a9cea0d6a568038b87ba8ed59c4d9ce4812ca5830198ac4b5"
    sha256 cellar: :any,                 x86_64_linux:      "7bb146c0650cb80e1d0b1578dafa832116f9266a84d3bc123bed45d1d8a013ce"
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
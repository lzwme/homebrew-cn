class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "2ce4e683291bced26a57dd35ca19e15a5104bd720dfd20fb01a012db4e747991"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ecace858b77ce2fa55856a144ef813cd5381c0c5614706f339736622689222d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ecace858b77ce2fa55856a144ef813cd5381c0c5614706f339736622689222d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ecace858b77ce2fa55856a144ef813cd5381c0c5614706f339736622689222d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27bc109ba6a893de9a172ffef8cf713e4b4da36cad450f16f32f26856414f252"
    sha256 cellar: :any,                 x86_64_linux:      "1744f48b65b1ab75f56e399c86d8c24196ec2ce3136152951d10664799911bd8"
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
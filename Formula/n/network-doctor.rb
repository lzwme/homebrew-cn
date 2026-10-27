class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "fb0add9dce23ab8e2d40585ddc73be66a92a75e5c041bb675e68d54c8d5c7148"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c16649cd00a74888f50655c33af043b8b4d8dc4e5a3f3ccab708939848cfd8b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c16649cd00a74888f50655c33af043b8b4d8dc4e5a3f3ccab708939848cfd8b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c16649cd00a74888f50655c33af043b8b4d8dc4e5a3f3ccab708939848cfd8b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c492ea5e012e4b440ea9552b64581de5c3bc773ba77e65b89d48b1d807c9c072"
    sha256 cellar: :any,                 x86_64_linux:      "eb894b9ecadf56221152f5421908b29fcdbf058ed53f00e51df3653804424f06"
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
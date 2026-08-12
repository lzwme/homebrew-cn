class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "7c111d821c4e73e221a90462988cd62958264779ec7d1ac42586b4be241a4be2"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c53ebc04e0343fa121f97e277a6d04047eff2f95c89c5be884dc15e9457164dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53ebc04e0343fa121f97e277a6d04047eff2f95c89c5be884dc15e9457164dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53ebc04e0343fa121f97e277a6d04047eff2f95c89c5be884dc15e9457164dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52bdf332eebcba1f069f55c1012c85fe1b3b8811bdc801cdbe2b55797229918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3e445bec5941b1a7019b88e9c4bb60ca8981a8f9814ef7de707a4afcecf932"
    sha256 cellar: :any,                 x86_64_linux:  "e2ac2f5da24f1ad0f3621d3fa5508e7f8472a833dc3551af8582dacecb5576a2"
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
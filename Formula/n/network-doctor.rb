class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "73f4c715add069acacc8ee871644fae5d6851e0ebd59039102567bcec5d23d8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2072c6ea4204f6e480a76fe87eb157e2881320e7e7b65ced99bb64d56e74b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2072c6ea4204f6e480a76fe87eb157e2881320e7e7b65ced99bb64d56e74b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2072c6ea4204f6e480a76fe87eb157e2881320e7e7b65ced99bb64d56e74b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "586606d5084400fd525ec8c7cdfe0c1b2fa0bdfaf250f32d65e5ec4724c9bd34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545d55a3aacd4ac87ee866e1408112c665fac82bc09631e1fdc150b58625e92f"
    sha256 cellar: :any,                 x86_64_linux:  "b856dafa9c302498a086f6687081bb6f840afea0efacc11ad4e6599d11c5ffb1"
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
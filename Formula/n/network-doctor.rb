class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "fdaaef6ec3df6d88f483c39ef96f80857e755fceb4363f2bb8819c31154679c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ab12a6f35b3b3be786b87b3eec9d7039f4375fce80b998342a8e751d6ba40a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ab12a6f35b3b3be786b87b3eec9d7039f4375fce80b998342a8e751d6ba40a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ab12a6f35b3b3be786b87b3eec9d7039f4375fce80b998342a8e751d6ba40a"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd86840209d08ea9f1cea5ae76ca932cf10fdf6519032733ba45b5480edf1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9679c878b4961d740d1829452299a31c3b5440503bfc30d9147793eede1377"
    sha256 cellar: :any,                 x86_64_linux:  "3fb88eae6d0a7d07d0ee1ac54abc9c8ffc0e6806ea0403e75127f44ea581be9c"
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
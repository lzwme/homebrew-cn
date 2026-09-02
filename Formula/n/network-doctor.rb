class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "9c954c36dc83d24decbeeb7fec6a2f379aca114eed165a0193cb35d0b64c9ee5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e70f08114438dcbfb08b7eb338443421d8aa2c48a65400145b642a33431b44c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e70f08114438dcbfb08b7eb338443421d8aa2c48a65400145b642a33431b44c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70f08114438dcbfb08b7eb338443421d8aa2c48a65400145b642a33431b44c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1122fce1982cd79086cf584052b17a804e064dc9e446460313c21488bccc5e97"
    sha256 cellar: :any,                 x86_64_linux:  "15ceed67b7406db07bb196a1c358eaf34ea44279ba52137cf31e55c0ceb54b06"
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
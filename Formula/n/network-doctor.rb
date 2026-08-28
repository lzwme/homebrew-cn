class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "025443a541a287a05281793e48f196aeebddc528be95c4d814bba843bccc5f4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e5d2ff4e90a9dce9cfc9b1c042e8e86e2d293f224874649470068378d38abf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e5d2ff4e90a9dce9cfc9b1c042e8e86e2d293f224874649470068378d38abf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e5d2ff4e90a9dce9cfc9b1c042e8e86e2d293f224874649470068378d38abf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68b6ecbdea6bde59e4cfe7c0bb8d5dca2afdbb378cb675fdd3bcf5247a76748"
    sha256 cellar: :any,                 x86_64_linux:  "9a4523e5aab7a460e1ec1154ff33c8d106ba1be0aafba2ea7470fa500e0bfd41"
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
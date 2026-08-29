class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "ee5ab98e9eddb26f389ad898e3ce14674d6dde2dd841f95be963ecaecfe8f7e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c4965e5bc6e5d66b4045030aba3d22889f9ff6532373636e7531b4f966fa80f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c4965e5bc6e5d66b4045030aba3d22889f9ff6532373636e7531b4f966fa80f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c4965e5bc6e5d66b4045030aba3d22889f9ff6532373636e7531b4f966fa80f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "674f1f1e606438a3fa8e169a89c5320076e2c2a7874a7231fc82a752e34d3b5b"
    sha256 cellar: :any,                 x86_64_linux:  "b01e916e0989391d1d0ed06833dbcf0904d1eb469d32f57b3206d91f1516e46b"
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
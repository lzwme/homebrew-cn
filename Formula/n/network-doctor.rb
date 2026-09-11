class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "faa89ece15dc1b1ecaeb02dcd59d4213bfe5e9b26d28f934ec6a922715611ef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0c0cb3410abb26abf146f1bc85fd6d980e31737ef6ce451f1ece76cef63dcad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0c0cb3410abb26abf146f1bc85fd6d980e31737ef6ce451f1ece76cef63dcad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c0cb3410abb26abf146f1bc85fd6d980e31737ef6ce451f1ece76cef63dcad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8af3ffe6620cfb5dfd7829d8c9d7088fd7e48579a36f3038908db7b7b57bc5f"
    sha256 cellar: :any,                 x86_64_linux:  "734b7e5f68aea39ddfa3e91b6d0ffac60c3f9c98ddf382204ec9c5ccf65fe9e0"
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
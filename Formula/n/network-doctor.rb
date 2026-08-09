class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "c27702e384b88042b4f23d578cf2f9b46ebc6e7c927ae2e73d8fbcb4ef32ac91"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e2df43da50277aff73c6cef651660da2730765084014e8215d131730c92232d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e2df43da50277aff73c6cef651660da2730765084014e8215d131730c92232d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2df43da50277aff73c6cef651660da2730765084014e8215d131730c92232d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6e35e04547eaebfc7f6e2f0a0f6939d958192a773eb20e055c4ca073e24dc8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e24addaca5086a8e35c6f2c1120fceeab91a3929d2d2b0a6fd79ccf6e3536c8f"
    sha256 cellar: :any,                 x86_64_linux:  "e8a8b3624bbc16cc8760fd5084e1c13021df1c712152289fcc584a524819f044"
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
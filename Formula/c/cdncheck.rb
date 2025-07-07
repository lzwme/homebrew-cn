class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.26.tar.gz"
  sha256 "ea68aa10ddc557426f4e1a603f78cb38c90c439fc0c71a79df1a6133a415dfa3"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db2efabafed08239ffa3903fe745c61d506d7a449504dd2ef3094b2a87f6444b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18adde5171e6d43def1cd133d732b65acf6221de85295b96d48f4123b9e6f2dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31c6496d7498b2cd97380df68d27698372b0e305ebe1ca7081c9aec7d24034e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "11685aa0255a20fd62c6a1cf03aced01b49df3a68128a95298628fdf8a17f114"
    sha256 cellar: :any_skip_relocation, ventura:       "7ceb674945e0abed70a64d932d4b8815cf900a4350d5fb3d3a60dffd4660c843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32afec400ca6be53f78c64ee65416aaa089c41c740d1912cbbad033c8b16a86f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
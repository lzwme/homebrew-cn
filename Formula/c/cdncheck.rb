class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.14.tar.gz"
  sha256 "7cc30a88c396019b32cdcc6bad12a9a0401fdf3c9dbc57297e5734b22e055027"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30c867e7cf5b4c801b44d58e04582d4747674d5908ff450456103e39a02e728b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4281d43e0b546bd846298129978c0e95fcf5afee3dcf573d1b5aad0b4abaaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5826d2bb0f30d5ea253ed581d23dd8a2d8fbd3b82b1e0bb898da385b47d21e53"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b3874aea038d75b12ede22ed0ee9d80915e41b61e4d8b3e764b855e8d11fd61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a19adebc8e05cdc8001d3f3fdcb7856e4b4823f7677ca6310ee46d367086a5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744e9721301b044adb19f168d9a1b31eb011780cc7523331605de321eb06c02d"
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
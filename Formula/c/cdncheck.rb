class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.13.tar.gz"
  sha256 "108f289fb4f9eb2ac733fe3c593a64e450af94dcc8ff62f828c2c39c0d46b457"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b5ba2d759655cc30b601aee9a69a64fe77995ff16498c9eb9f50dd70d778a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aa4244cc44370208c95ad7b73838a757e3eb36e5fb0b8fb4a5b9cb85532f7a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d3cfc82dd08e7e2a2a3431157086222ec6a9fccc6fe3fc2c0aa2be574432bc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b206dc35c412b18e4ccd9655a6863b351d991694816dfefa9fcdb7551851f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f13b217c950c2d55d25a376cfdf1675be6bae2ec482cc3892702275a93006b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f89f78fc3a77daf536457f408175af50ee3e996a7682af22e061de1b05fe57"
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
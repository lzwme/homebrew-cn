class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.51.tar.gz"
  sha256 "a26ed6dbe3b1bc1fc707a8c7d408770a5a9f6fc01e8d244a63c3bef9eb6ea10b"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78298dfbf481117fe2433607dccea2c663b961cebc91cb720dde139dedf66b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b1ed35de7d1a6fc15de923302c5fc900e1a0cd55ae872e9442e155d1da3d152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac349c39db49dc11ffb7b3de032f2e15a2412413af1e3a3149b55e74470d70ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7f74944019a812a0783336aaf80e7381da0ce4751ed2b2a176d38802bd0e82e"
    sha256 cellar: :any,                 x86_64_linux:  "62b7cf891d1f27c6af53afbc0c8ee3b490e392d38cf2e716c2ffb8fc8ccce794"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
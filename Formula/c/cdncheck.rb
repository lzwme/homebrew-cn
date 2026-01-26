class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.20.tar.gz"
  sha256 "18cf061e4398f1070ac5bff4b96d4bf244a6b91a1802ddee022659f991adc633"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "080dc7e13ab2525c1829e2d092b3c4f81ac25fbdd8b4c529da99488c373bbbe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2a56c279c6039953961e69061c11b4bb366a9104e11c711ef98e5ff3c120105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50cf95f55c9408f55fcc0b2de806cc920aec0268b232b48066329ec6573123b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a05a5a07123969240e15c7140a9245515c6cb9dc8899339d5606440c800de03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0e9e9e67c3b7b960da75107f853163aeb58d52ef99e53cf957c3921ab14fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f79a510cec198e27ddd5e5ac4760a004276417223262bb74d6a8b9006e327ca"
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
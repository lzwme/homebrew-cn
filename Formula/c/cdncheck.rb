class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.29.tar.gz"
  sha256 "c56cc4e5297269014cc8d1286fef3be7cd2e3c22db7fe229df374619dea5715c"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a19170f79fd78b668e4e6401167f4f0bf3f7658fd5906c8cbe8f050b617796db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e1fb1f7e53557396c732342c493f0cd8f66bf7a3510e8fe1896cb672c718773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b308e77a598116d1344a932a9a7a2e9581dfe92deb09f9c42307ebc50a63395"
    sha256 cellar: :any_skip_relocation, sonoma:        "754ca662e07baf5da9b97a2eebd63cf7bfd32990a38dc7638b7abb68a51b7867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e6f55102945121569f4eadd8d31aba3c6c93024deabc00fb665fd60d635f1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d48381a2a440c81c4e4711822728c4c369e577f0b63d0d08c62cabcde70964"
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
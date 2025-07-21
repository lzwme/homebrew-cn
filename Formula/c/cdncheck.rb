class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.28.tar.gz"
  sha256 "4bf0b6e7396986bc05c998d5c50a2b08a97743aea7e10506a50b9d0769b6dc59"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dadbaa23c72e41b7c648d490c1ba353abaafacc61cd40462d997a40d25c1c4cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a0444b9ad92d52b9e9edfd3ef7555147090d9e5bbbada35c98e4362ea077531"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ec3112bc544cbd9dfff5ad559d2be9935afd613ffd212c884d393ba91a44b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a3d7b5b21e8a2b08e0ba6d70b3e35e397739bc2ee54dfe8d8e414dbd3f24e0"
    sha256 cellar: :any_skip_relocation, ventura:       "54a399033173450418c2eec8d1b8d2ed70083be0d06b605569fb5dd63b0558b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdab1351b30b2eb011d8ee3a56ba6f69062ad59c581f0e5699998f40e2479a2f"
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
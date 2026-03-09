class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.26.tar.gz"
  sha256 "2b43b507033d65f19f6b92069312edf3a053d5c78d238f2f25f0df9960549e8c"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd1f72085d4332ebbb7f5a9ddf6d0d9f004cc00b1125cf68ba8f81e1a35eb23b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13481a9c3b0d272c16e333f55406eb942632c0f7961e5026ed0d07f3b053f79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07b7d678c437798dd184e3abcd3ae675433bc58a553760c2779ea9d9831e40e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "830f1c7d805fb3c42f7ede4320ddf7aedb31da3b7bdbb0777c3b861bb1fd33e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f57742bb2e8cbf0f2630d9fbe2745b66ba225f6ff85dd02d64a6b20c731126d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b1e7ed28b64725bbe3144533c0c5a0d4fd21b6557fd194c7f6cc29c02ab72f"
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
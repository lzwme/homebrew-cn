class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.38.tar.gz"
  sha256 "ae95f2fe528b70019793346d461cc958e159e13b07045850ac49a85499142b35"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b1e1f2b08b03b42c4823e9ab3ecf3f532a5cf2ae1b18d062a0941c24eab5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21ef73d01b17ea3f59a5044c09e5cc20fc5d9f6e87036d599af28f51202a20b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1669c1027c717e0641a548bef97ecd651289f1f4354410b036c00c1332edad87"
    sha256 cellar: :any_skip_relocation, sonoma:        "7356438d6b3936b9e4a85804bf67bcdebc1cea4123d318d3dade7b2006bcf5f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93fab477e52655a6579472685f05162c0ee030a8f9add2774ecc4f14dc9b3d94"
    sha256 cellar: :any,                 x86_64_linux:  "3aa9ef902dcacb0e4baf4fb4b4ec8f0561ba73775236f1ad71cba77fa2b68baf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
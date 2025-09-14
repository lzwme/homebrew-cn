class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.35.tar.gz"
  sha256 "ee8737a35705b8414845dc572d80bfa78deb9321780ca3d51f60a2b406cb7827"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2a6d74b130e2d6ebb8a40764d2f83405e885b5633cbbfdf027d7480720a666c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40440a18a4e92c012c23dd96280707f39b17ed95f356a47919c7b2ca36954f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac31b11b311d0277164cae565e8973ba17523ea33f93e53c825945da77b65c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "751bc82c9e14970f6b2dfec7d6efd5589f67a9e24e1c8ba8eb440a412024dcab"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b21113300bd7978f975ac9fcde7e786f57e564c54b3e8ea5347a81f0fcc9bda"
    sha256 cellar: :any_skip_relocation, ventura:       "a2308edda8ee9bdba923485910f9605947ca421922b3f86d528382145135871a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa2a31e963637c8bee056e652ce280fe426f5701e50d05fdbf1114334cb1f565"
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
class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "e791eadcceaec9dfe399db4e99406326e6105022d49882b9438b406cdcf48779"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a66e448e01b1df36f0dcd1d0634183bb3a94ea31a8e1a8bda9c44ff4e7aad60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7f8202b7ef76c8614d128750fa0bcbee831823fea28ac7e5ca06cbeb9f62e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361f5f3aba5f7805d3c33d3bd04f519a86029af780e869c936c6b243c6b4f56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29b385fe4d520c3d38650dbac2d5d0fed9352cd17f1937ec5fb357fb23fb1fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb70d5c877df89571b2957a216805cac489c41ad9a2b24c0784773b3b21464dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d299782d21519c5ffef966ea853af92f06fd42e13df48fe1ea6c7499f68af9f"
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
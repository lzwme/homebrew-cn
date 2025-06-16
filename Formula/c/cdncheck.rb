class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.23.tar.gz"
  sha256 "4bb9696c1e72f0c366e99aaaf9e01e2ff742f3204bb211214290362bb3652b53"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "612857c3d9265caeea4910c88bdc28344436aa9a7d798bb4f12fc78fa8d94f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c33eeb88c29e82d90a15b3cedf5a63847e7170917647dd152a44ebd93edcf547"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1582764ed6017c3a1afede906ab7f748f1ec4b02ea7040d95bcd78830f479848"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ac45aaec62f655a772dcfa83f3576359ad765fe8ffa56e28675e2b4b301f925"
    sha256 cellar: :any_skip_relocation, ventura:       "32ce5738f57f34e87a2339eb612145e5d4a66c3e40d5574e1126b7e3ca0c4463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1a2181e96d516976a558dedb9eaaf5f72efa295e0e5bed70834580beb9b969"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}cdncheck -i 173.245.48.1232 2>&1")
  end
end
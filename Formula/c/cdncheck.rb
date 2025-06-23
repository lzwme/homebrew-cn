class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.24.tar.gz"
  sha256 "c800e780760c4b300eea2f9e9e6bc2f9644a353342b775a53fe02271c90e6d88"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd4f880efaa9f6a1a90ab52516eb3f256eac30929efcfd48918fad4cbd363b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c505d28dd6ecef0635bec295d17d4a754fc674a4d9abda94b8ea6d9b94dd627d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "655932e903fba428cad0a86d2d20c01aa327632ca49a700004eacd16a1288b4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbd7f0df77d66476f9501513e9bda7871e6f05142daf23c6d3772f17ed6cc9d"
    sha256 cellar: :any_skip_relocation, ventura:       "7dd295a9341f6c9dadfba484020b51d7d88cb543cea68543f0590ecfbb1b2ebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c62fac2f79bfe01041609fd0b1bf92eb53552bff375a5374871c9774b9dba73"
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
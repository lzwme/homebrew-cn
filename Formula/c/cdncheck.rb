class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https:projectdiscovery.io"
  url "https:github.comprojectdiscoverycdncheckarchiverefstagsv1.1.10.tar.gz"
  sha256 "79d36623a54321a8531c9ab6278e2a6780120d668d002b56a6ab8af68ed42a0d"
  license "MIT"
  head "https:github.comprojectdiscoverycdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8e2bc4bda0dbc92e53d4ce171cdd1d5041528e8a9b6231cf9e8d7206545e7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995928d968287137b690d5e24358ca52a33e9570de0741f5401add7d560a9ab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09161a0ea392c83c6823bd4c603929f18ef31785d544c53082119037ac8915c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed21826b188d9548571ce3c135af764a6e6d3e173324c068b1ae3a9fd876f20b"
    sha256 cellar: :any_skip_relocation, ventura:       "21e402a825ea27225942f337ecc899c30e571899c8369f44466c07cddb857c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a357637d8455dcd9e6a53cc2b28fccd1b19dc09ba5c8e5fd6f3535cc8f18d76"
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
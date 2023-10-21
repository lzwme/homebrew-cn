class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v3.0.1.tar.gz"
  sha256 "cc9803cf38402e625945db7ddb9e881727d6b6e482b0a288762370c65c430714"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f295be2d0b3a01a090dc0b99fdff37bb2912be482db0357f81e265de11ccb13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee107f036c2d7abcf16c4f5095e5398a1281308b5b952919b55ff7148596bb1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11f4a48b87eabcc53560efd1a8b17b9f8a08b900b484cbeb148a09f5a76a21a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9bcaacf70887d48c3e040e0441743a9cc2e40c30085ac66abbf5e34c44ca871"
    sha256 cellar: :any_skip_relocation, ventura:        "1cbfeb1e713c0cf0b06c3c3ad7d0238511bf502cf29f9d679fc449fe6811a552"
    sha256 cellar: :any_skip_relocation, monterey:       "2045208f01a6f8f35bd97c2ab16486ba511388139fff500ade42ef991a5e2a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7c2e942362f8c3cd3d887396686244319edb9f18f7437fd6ed08c5493ecb223"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
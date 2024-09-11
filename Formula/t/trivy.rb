class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.55.0.tar.gz"
  sha256 "4954760a679f1888ffe66428a0684e4ba911657bf339df65cc5e5e11869b5421"
  license "Apache-2.0"
  revision 1
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "834df0beb3f42507ad387da8ed99260be8674d17b8fbf5f152bcdb9296b1d2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1158aeeed718f73b70a72812a47fa333f5f4fa409bc5f4c58396475bc60c378b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0306aff914056842d663404118ba25690696bb8cdaebae4cd86c8a65bc38e3c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aa73ebd27d719b75b2d6516b51bf280f890fc4ca6e5f184a50448e7aff6daab"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f01168c5a5489af0f62833c9ba64c6003bbc1ba7b359f05d67eef150f7272ca"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a2cb7d80fef9e2acac43427a2a8e7ba862849b0093a0ae8ff0fc1321d895c3"
    sha256 cellar: :any_skip_relocation, monterey:       "e6411214002e12441d9e3ef8bc0cd03fc4eebe84572c8328e55562408879ca7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa72273c8968e44e598b884dd6354d839f3fe126489dfbfc98f63b8d0c212084"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
    (pkgshare"templates").install Dir["contrib*.tpl"]
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end
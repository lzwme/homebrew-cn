class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.55.2.tar.gz"
  sha256 "4157bdf8b72b16064f5b5b8487e25b34ef99cdb49606a69a56fc4a91f4596aa6"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e37c0cd89e4ecebd39e1e0c68e0deb5224147cd3b028675f20e531f5876abc9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbccf74f87d8270ac862ba12dad5bb3263432fdb5428465aca6866dc4e599c53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9af360e1237453c40e8f414f55df0e6b76310015d05bd6839919cc86d2fd5530"
    sha256 cellar: :any_skip_relocation, sonoma:        "6723950fa78438713742b4555713a3645f7168812500bea986ff78f386443952"
    sha256 cellar: :any_skip_relocation, ventura:       "02dd32a4a4d6829a42d2e1008c5592fa5782d862b08b09a3a05acc65ed0a861d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b8460c110c3ee72c60953133d9876c4db44855bacb172caf6aec09f9283842"
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
class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "22277be490c50893f90ee9381a04c105322ec952f7da9d601bbb89198937c3f8"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9798fbbf1683a0348da9b59c208f036e51b20b30ad3a1a7460b1582681eb7dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "559fbeade153e0983b69ef0a74670b0302ab324d6fbfef7b6a2ef04502cb36d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b89521da28e0974abeceaa1a416e2a4873592b9a64bbebc8d9962d8b6a86449c"
    sha256 cellar: :any_skip_relocation, ventura:        "613331ffec720ab4f88e997d3f8d20f5e652abc5caddddea1b559964c7f52533"
    sha256 cellar: :any_skip_relocation, monterey:       "7897abb95cabf4d2aa8b2955a75b3fc50c2ecd72ed00700690ef9d09198cc312"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3be04b3276c15d87b180f16caa1e7be9349ca869fb90c677e69778e0de9c61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4962d7a625adeb493e9d192148f1ecb56151b692246d05cdfb7c6c3acbc0c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
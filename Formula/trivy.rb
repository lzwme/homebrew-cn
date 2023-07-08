class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "c8e55d945c94a0c6177680b0953427883650638e1588a5e20e61e762c902e213"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d4e52e18db5492ee06c80e736f8e6312a2e8e8c8ff0062a3156efead0111e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd058a4b8a7cebdbf0bcc1d71e1fcc625a9456b973fda7801fa6dd253a2b594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a37808f60f740b6a02b808d54a62bc04e77a578205be9733e5b7efdd98ec3032"
    sha256 cellar: :any_skip_relocation, ventura:        "a0cea30bf2f12d7b2f7a328ac676e5b4f257676113a3f8962baf51a250f041da"
    sha256 cellar: :any_skip_relocation, monterey:       "e9f6bd86ab3aade55dd0c670da009fbf4f0c13405de4ee34cc02ea64a40078f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "05aa831b44723cab60e9624efa627d9cc256bae9e06023d41118508cb1590e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff962a394c8e9786e14f930011d92f4b1f1e0bac02171106efb6a9ce1290964f"
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
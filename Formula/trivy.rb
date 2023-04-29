class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "22df9aaf6bda303b0677b26263410e87291870261ddc38abca6f32c640e105aa"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0354152597c35c4253c628a53544bb5bd5af9e6399bdad1c8526b82f65dec8b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d30d35215e0c2d2aee5ac4aef16bcc7d84ffa99dd022d777ef2ca72fe45856d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2b8bcaf6fb704d67825195af81fad637cd9b3d0511ec19772729634838e9d02"
    sha256 cellar: :any_skip_relocation, ventura:        "89309776aaad082755270eb0b9bc7d7cca8f8d599913c53421e185f7854e53eb"
    sha256 cellar: :any_skip_relocation, monterey:       "121402b882f32aaf37749e9bf5fafda5bc7b67dbb959c529778472d169b72ab9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e83339a83e0936f95c58fb7dad8f40219f2e59db430875899248aa8eda7f9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484813a48df15e72b75d5e7360e5c73e20fafda27282ac95895be3b4042c4e3d"
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
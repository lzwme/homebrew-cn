class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "15914adfd0e86b35cde9f10afc23c0d12950768420de03ee82ecdd78d4cf3fec"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a9f43dc95569a8848fd8925fd9fc56e2312470c844c14541280478d378ad92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c7a0f32f4a97d0ecadb2b22c0b3e54253edd7c3e63e5f045629254c6fa8d57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8435be081e7cde712df105773e27709c3da22428163a0deee4f479fc7ffbc89"
    sha256 cellar: :any_skip_relocation, ventura:        "066b746d292cfcafbab2735cebd5a241b857557446519ae1635e05c6b3919952"
    sha256 cellar: :any_skip_relocation, monterey:       "d3edde6d81881bfc3aad900ca5d89af15b1f6787c749ad42638cb8706522c5d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f48c7bc853190c300a587c858b08650e5b09a5b3d01ad4b715be74ed8b4ab281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d0a3e4a6a3f970d37f3841baeed6c34a727a33dad69f2670e3fb313771ba9e3"
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
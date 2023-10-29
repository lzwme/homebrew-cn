class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://ghproxy.com/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "174c14da3494bb5cb350154fa902abc53e7e617c7b63c994004448d9f719d02c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42f7a367ab5ce9bb70b297c5cf236346d5e8186e006e344b4deeb328c639286f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1557e9db6d133e87a7e276e010491a46377da7431eae69e4ea73f83e81965c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e523f81cc03792573ce65757f893a441c6dd49c912902dfc1d53ebb1d9d07ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eed4145a92fd43aa424c55a0b43b1976e21898a0b446f9d936b252003970f02"
    sha256 cellar: :any_skip_relocation, ventura:        "b6311afbf10ece259dfe0ffe87a247c84d04897f03da669a464fab70f1e8a4f1"
    sha256 cellar: :any_skip_relocation, monterey:       "d322e3cd110e7bc75f2377192bfe4afcfc7b9452cce399c0e9c6da76cf820277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b55331d82cc26a2e46961fdab80050a98af18a51ef5f96be1b52960eca0c9ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
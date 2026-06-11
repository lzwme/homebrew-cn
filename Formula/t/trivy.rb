class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "fb79664621120e700b89f6a4642204787d43cf24d7cec8f37d8a39d26e8bfa9d"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "673367a97f27a2a5556faa4af401ccf674079d81630ba987376f59a9f63442da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65af907a0db8ab690f8618d19f1fad30f56c7045c639576f5dea48794bcb411e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ebc3cdd59d2e0a802d08498e9602bf0398cbce2d51c898e90919e4f853b6198"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3aacca33e0e1e4cbe53179ec6cacb92ce944585d09304a60e8e37f1ea7de653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c386ad042c5b5f741fa77387b34953ab4eea638369f53a73d0fddad683ec221"
    sha256 cellar: :any,                 x86_64_linux:  "86a9a0d08f6ba09177ff06b56435cdf9056d68665b6130e8ffbd1b4d2b9b506e"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
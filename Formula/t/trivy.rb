class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "4ee2010384f90bf23d4059ae49c11129e5041816a3754d890a90ae80f678d765"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4fe3192f521a72e0100943ffcde6d4eb3e2d2e2ff02b4bf4038726de90c57909"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d7f287ed34d2bd244e27d03fb56f28107d9dfe873e757761dd356281a5ec0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "00587c5652a9c9ad7667a4b70af180cadaef5a05f40b0fea94b51c97a9cda21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7bfa5bf2cad495975da23f7ed4df0520fb6149779765b595b36832897ff8dc0e"
    sha256 cellar: :any,                 x86_64_linux:      "308cc089fc0abef3b37c9db36cb5e531ebdcdd967eb5cb7c97c655df055a1c39"
  end

  depends_on "go" => :build

  # `test do` block downloads a container image and the vulnerability DB
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[-X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}]
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
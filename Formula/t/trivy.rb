class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "a2a6f9eee305dd6672ec3af92954c456e5f5439ab3a46d6f4dc06f53422752d0"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6efa7094ad08636a51543b7a330198389c93db70f0747f7109a6a9004d805764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76a2ea71c42e39b41a92d830aab410807a66db863d11f0db81b18c9652e25a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b11ed690b1aa8e4968608c2b6f91f68ec48b794df3ecb804c2d2fee4cdd859"
    sha256 cellar: :any_skip_relocation, sonoma:        "907648ebb3f3c91adf2f567e2f77095116b08a5741f02e405dd347f4b5934101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce2798524ba9d3526033585cd96da5228f86b68e6e971a414cc6494e186e7bec"
    sha256 cellar: :any,                 x86_64_linux:  "b0c65203be5d900e181cfcb9f0a94a53c6301661c5b803a381c3808c422be18b"
  end

  depends_on "go" => :build

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
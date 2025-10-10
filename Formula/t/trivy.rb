class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "bb6ebf2321f2bb8cd05a9eaed6e04c95f649d988e1d4452a8170b257f668c906"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "208b4b0e10adc7c88fb8afd96fdd98bb9889b972d965e46a4b9f7a411782542e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "919f50df1d6884f31ed7bf1f74091c9f9c21fa9d192b0bbb0ae5f5cc25e6d146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e32687bfa0d786b3f5b89fcde5ab57b99f5fba290870d8096e5d914ba051cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "619fd707627d1a8f7fe9f2eb924b02beba5cfbac91b84446bdc2c6c89782c84d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "618a3319297bd9b6f2bb1dbb5c53d2260589a1656948b2261fc2bd908e4cec52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df11f9908552bf1757adc3d5530b485ae74a81b981738294cd7384f562ef91ed"
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

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
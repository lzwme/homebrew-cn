class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.69.2.tar.gz"
  sha256 "7936a42402f60cc9117e96cf62440b206d6c919d1f5073c824aeb457096fd026"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b01025712c9313536d46865e3f88845a72000c6a6348020cfb516807127b9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae48384cce9cf9db59d712ec20969dfd1a12692cfec7b99552918e9da650e1c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8a3ca1131d045b487815c0b289df4d2a699c47e3556f0d936c019bf80a97570"
    sha256 cellar: :any_skip_relocation, sonoma:        "054fea4d09a1b3b3a6698b54f89de085e6070b8fed88f488415e85d63382d84d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf703d0adddba4ec2995f20aacf30d021333fb88a6ba49b9d23e08c5c934b461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "267075d92aa696da51c75cf2420acfc189ed6f5c02d59886e83e3d699e5311d0"
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
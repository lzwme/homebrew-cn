class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "b99b38c3233146a386b45a751a5340a744eb47cd438e30526c23e25e4e719b6c"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "061e2e84bd5ba3e313cf74de049090e3086ad640b64aba5e1ddc0b8942cad2ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b792271e87911c3fb051b5e6612e04c74c64f2f0768bd6a89e013d1b128fad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0412ac9bdb03568d6d7baf0d9f9e129ea43f3d5b579f4178f27504d8d9afebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef7158ff917f7cf44dbf2faa004a7ff7013e55d301ed6659f3e867de3862c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a3ac6c760445968c8970ab89b4a6e8cbc172e2380f571ef2bbd4305c6d4807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d57559e6fea5834617553617f24f2157f9cc55caa70a4bf387a8bace1320e11"
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
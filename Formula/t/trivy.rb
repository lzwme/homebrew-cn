class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.68.2.tar.gz"
  sha256 "dd8efd719709d09b41c98cdb9090654f8ed326f07b05ba7a4ffca4de2745aea3"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "736fd4c3a992c16693cd74d4a7428a1756851d364158167bc87941c828457a05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e8a3619a4b6c62150a08e555fb0ebd5505a6fec9e12c79bca16173315c4f5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5c31854001436332bc33e38a463c53a6725a0fd0161f7be272be2e05d32890e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4063537ebfe4e8fcc5e798be1d1872924d4fcb11d6fc70137a0876072740778b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ac448206616868162188bcc8fc9dcd54c161b58222abbc5ed094bdea03f004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1896cd9a6ba970660ef27ecb7c5faca88e6895963ac5f9e6deb23ad1be1440ec"
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
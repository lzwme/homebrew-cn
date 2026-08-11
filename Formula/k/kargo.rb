class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "9564d957269f20f5b4593ecc88d7857656a8460d04b5ffa7c2badb100257b9d3"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d15217e7d75bea4f1e7a2399f17e51f378bd82b8f5b0bdb9815a5f545ea6f238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ed22378fb3fca10b08425da66ea134951ab93014494c5909a822b9457932a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e61eacdd54b560c6467543d0effa19f2ab85c44ec5350bd9df786e836b2f3c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "78e4d0bbeef348c603cba4b9893b38c15ffaa2d9f3af16e53071603c67642a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10834e07cb51eeaaaee28b0e2b34f94b19789b1b3c583b2d7a705bb48648a0cd"
    sha256 cellar: :any,                 x86_64_linux:  "67a8c67b5a2020b6f6e36a7e098160b89c6b858a039ab6615786062e53d07f24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghfast.top/https://github.com/anchore/grype/archive/refs/tags/v0.120.0.tar.gz"
  sha256 "8bf9e1c197a956dade39879d75836d519a075baa744a0dec45a8ac3d042a3d3d"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8778987916721a7602972159c60ea5e84e979218143235834f2b9bb0142236fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7fd418670df62d3116bf143081ad84722dc0ceb119d054c2d96b294e847a018f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d3d295874175c0ff02832015000e78ad65821395af10a4d7100e874cdbc901f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a27b76f31e9b222e6be3fb171f4560c0ede13fa2ef9e8f76a150b1d1647b13ae"
    sha256 cellar: :any,                 x86_64_linux:      "043861ec066952c390540fa1a511cd7cff2d44aae81e03e1d5bf430c210611bc"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
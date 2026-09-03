class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.2.tar.gz"
  sha256 "38a25b3b59350fca55c029379704ca2ce8ad21a43b0c038b1b3f3f24db0a5ec5"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0caebbe2cb7930b065afc6c573b84f6fd1e22478c847b5dd6c31bc0b484f98e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93855b8a7c82d7ea459153f9b91bb9d3912e31a438ee359468dfae559fb3a730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d75ed5d26f7b6c5b5d032c7f24380ed7b29387006b443d5b8ac1ad8d290498"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b60520be33dbb82de02be377195be624c219920f983eba5d52961eab8729576"
    sha256 cellar: :any,                 x86_64_linux:  "0ccc334a61459c8569813576762a7ed6fef5dd32781a4c63e91288f31b04f543"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
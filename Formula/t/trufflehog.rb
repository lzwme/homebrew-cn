class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.11.tar.gz"
  sha256 "b6a0ec9a6c4dcbc1c73289da704f237a0122592973bf44609d2270e622fe6dce"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed0c3c950608ed5961922da62d7dbe96641be80b5fd4fbd289ab41c7ee23145d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904936fb91cb7c1e8240cb79b48433f2031cf034041485413f9fc650bb065133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c15f75ee3a3bb8a17a199974f2ed211770b6562dab46a4879743dc2df2cfd62"
    sha256 cellar: :any_skip_relocation, sonoma:        "d373f928546df4185057539acdae2d940682ecee0e3674ffd26f6f0d47b5ceaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbca401638a2f353312817035419550f99031d2e06ff68cc2845595f26361014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa599852a52da6c9e383c6ec62ca2bdeb4b4e7d8a9e6faa7c5af5b3cad8be0c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
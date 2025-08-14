class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.4.tar.gz"
  sha256 "641f297236c3fddcfd865f7e8935d0ba5e93d679c366f861f640f98783793b9a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bc1f1b3e3e19270916aa4daa86dcdcfeb448a8be0f9d11e49adaa6bc675c80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f59e2ff5ebf08689693ce31d2c6f7acd4710966d37ab39d3cae742d8eb8b70e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e1dd37c5391613bd6679a4c4206304db52b90a449effd1d59f8de44e21cdc55"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25dec0b3b7690bae5cd9c5d91b9a6d3f03627975b4a2a1ecfdc23dba4f76351"
    sha256 cellar: :any_skip_relocation, ventura:       "46ca63e93e930ee87e502951d7834df2960758a55dc5174e35610f0e111107a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b4e9a2258418806818222f64d8091122974937a6578ea3538f6f89a7abd24af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1068218e76648bc39330d0f234ce629f7ef5b93deb30cc55275e925f4118ed87"
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
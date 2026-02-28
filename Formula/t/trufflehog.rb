class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.6.tar.gz"
  sha256 "f2dec39ae56633e7c94f31e05c7a5ec51907946249e5ce11f81e35b525abdc64"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b591aecbe25c0d0ea9b0008d5a914caf35a1e8e32320aa195d87ad7f58d7a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b4d9257d2e9c3fd973a1ad5fc3a45370e8f43c129adc9b00ea4a717722671f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd2aab450d39351db488c4c2213f9b81fe69e01dbf1fb4623e8b2333441678a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "60642ba8d2d9f2213c424347fc46ece43efd8c734dec840aef49c3e58cac0117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7604fd5f7a9c6eb445300ca62ce174fa8bd20f53a0f6b973e47993da4a8e961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e967013c6130461229e5b7e5dab9bac884ade408443e5132c79e656204bddd5d"
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
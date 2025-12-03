class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.91.2.tar.gz"
  sha256 "b04822e98e106c7bf572ded891f5a9b13a54c22ca6052f50eb4ba2ab3116264b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "188269f619eaa2040dc55a38a40c19bb89b545d5917a86abb320ec9e0181aac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b108554a9f13b53704cc339c0da5b4c7815787d18408a2a37795c5bb4d131a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c31dd8b0ad14cb25ee7e356990270eebbf1b3b4c48ca9419fc3e47a31e28b5fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9def573e51d911da2dee34864922f799be6cbd5be511a82ba223af23ab59269a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4355f771ff17ee3265e70e268235fbed539c2adbb547ffc1047674b989e9ad6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab755f2077eb965056bcf317216387477db0f1c646f60e239bd2382a9c194ff8"
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
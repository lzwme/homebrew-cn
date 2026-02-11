class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.2.tar.gz"
  sha256 "337767b44dd5d1f1a0806f1ecbaef7dd319888c5e0b825e164ce1881bebddafd"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "402f8c107708f385c3acbfcb98129474079a2128e451fbc6e35438b78a896163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ae807a83b99f5b26a449b9b6e0b456998a02d242b53329187364a3e414bfe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44d3563e742cc60bd7c71556849d53187a58cf3390cb40786dc0aa760deca93e"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c3f8cd22ae1b6b60fef0e5a97297861387b7519ba39c0c6b469c52685dc49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b208a401aa484967e9a45b79229e94b686ed60b36797bd27ecfa7a4a0c42ee36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6e8bfca133cd0fc264ebe28bdf5225ba8288d33e2cb47149cd74b3fa1faab8"
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
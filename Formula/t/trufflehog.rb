class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.60.2.tar.gz"
  sha256 "3e0359165762e75b011b3bacaa07658de18748a9ae026f499b8867d69aad1a7f"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8e8ced99386f053bd8803d1cc700987b4739128b3097ac4661f2c03852b8a54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef51341d732f887a386b7d7526f9239eff6c4b28301c8f3a958ddcb89cc18a71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5cec1e2ad80c4671290bb1c49961409919fcd5f9933d899d8a7a41259381d74"
    sha256 cellar: :any_skip_relocation, sonoma:         "b77073bfc8b8fc91bc70c41ed696b63ff588f85643d0a1e60c64fff2641d4bdc"
    sha256 cellar: :any_skip_relocation, ventura:        "e7ce0488a8ca3c6963b5e097822f0c917676c6a3f9ce6368372dac5bef8e78e4"
    sha256 cellar: :any_skip_relocation, monterey:       "8f7c9887ff01543d85c3fa27a420ec3b2d9e2acb44c913e3e6d5904ea053d8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63caf00fed2e42f814b6cfd8f1b0718ab671764159b78e34525d96835b7d0fb7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
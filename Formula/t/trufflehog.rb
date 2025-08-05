class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.3.tar.gz"
  sha256 "830fd3279b4dd68c90f05bc13efe8f34c2dcf05f3e7875455f5e4ea82ec4e328"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd19cc5bb0db0edceaefa437241c0b50d70a60fcefdea3f0c648f8a98ab1f21b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0b50a078674128ab9536259ae991821f7658655a63867c09e5c0c720cd34d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fe3a19e8867b85c24d24aa83b6222ae19a14868c4e32622565e30e779a9940c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0328f371ca002be252267cb613167b082560f2f34e6d0f04226b74cb676b127f"
    sha256 cellar: :any_skip_relocation, ventura:       "e0d0e8a7e4242b89ca9a1cd3afd046b50e2f28af40ac3a10dfa7b5c9726e179b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80620cdd3a7a104a3531bf9f93a1c32d24554151113c40e7df8e615719a33b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a2a9df3b456650a753fde2a3135f758220e75eb8db30737308e46db8bb756b"
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
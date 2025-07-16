class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.0.tar.gz"
  sha256 "f4c8a15ffa0f0dfdf0399e0758655b6eae3810c9b1be63f85bcb5215cf21aa15"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c9ffe3ed86a517784f7f2d3bf687c60b0a4620c12a63c92ac723bc1e4475ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af6a2327d6a6e6f0c9a9ef6c7d86d92969cfcf8e331fdd941841bfb8965004d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6ff71a659d88540e0aa04a47085fada03d7681b33cc178fd97e17d4eabe7398"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8233fd52ba853c69009b48a77248512d901da25975c7de2884dfafced87c67"
    sha256 cellar: :any_skip_relocation, ventura:       "912a436c8b86475c03b4993859c046fa4643650899f4a134f05302ad2f52a6bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00988cb7b1f6744836cf1291bc345ba35997dccebc5c401e53391a0902fe7391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a09077302dd6013703b2b44f42d5ead7528f137d3d2c9a7b6248725bcadf48"
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
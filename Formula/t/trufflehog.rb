class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.0.tar.gz"
  sha256 "0361df101388f225566c92b66fc4c43648ce0d3b09a899de28d0a4e1beff437b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c56c7d46f221e643c69c273492514970c07b9d899e5375fbc3d6f231ca64ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03494b386758820fb382852d60e7fa0a6d4d4265e6c94f49e713f12d1f80f693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114476fbc0a0f6ed69756f9beab788d488ee85a69adec33f84727aa05d3b0a9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a6f0ba729e03e39c58ce685b8de84af5761280e5818bc7f45070847f05e668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8109bb5c98dc860559042d9615502b7827df60126aa96b6634d6a7bf34e29fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7451baa1ccc75f59670ea09ce0f42218469eb987a1fe6feaaa9f5027e8126244"
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
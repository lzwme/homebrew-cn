class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.53.0.tar.gz"
  sha256 "45aa1cb54fc8eb0dded90c849ad0f508a3261393e68a42efe3e352166f645f6a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4492c7e799ee308be9ce71bf674c2381adbd30fac8cd6b3dd101d519763f979f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8d16b90cb0dbe8dcfa187ab7efea7d1a59acd814913e21c0f9294210f942465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69532b1a945dfacbe989119951b76ca02ed663d929b0c46ddd78a3d0cc051b04"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6ad0c4cfa88dd7caf153c2a7373af5b5ea6da6952986340cdf7923b3e17dda"
    sha256 cellar: :any_skip_relocation, monterey:       "afbd41a3c7386f4a9ad545b5f146b411c6c715abad38500ba8e0cd21b76e002f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ec94bd0c10adf357a6b1bdb1c2352d88dc123d7206a5c8528ba95136c31ac07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d0acd691ca7e378aaf6f5706d38f704f32d234c27deacb4ea34feded8991e74"
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
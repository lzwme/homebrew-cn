class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.2.tar.gz"
  sha256 "96782b2205c412ce0fcdf2538ddeac166a86c1ed907bebb5991b5dcb65c3e34a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e829c1817b1a511ee3c9d6317ad09fbcdd92b85101d9694fdc9c975e85d89c9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65ccfc546fa866b1775432b36314d50bb07314bac698728a5e6f53a276abecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daeb8b3d26f871fa9f29f3824959a4f75095cb1a915f7153e776c7a142e8c34b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b36c27f9e8b143e5a1d015daa42278a08bc3d55621ceede7ad675d1d72728f37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b743d7893f319d0cf20220ed6931bead7074aa9e624057f1bf2448d3131fdc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db232ff9193c5358fff9af83f68e6cbd1f6b55b14d063e50189c7723c361223"
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
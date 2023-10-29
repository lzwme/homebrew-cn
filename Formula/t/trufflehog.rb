class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.61.0.tar.gz"
  sha256 "f4ad30b9518ca93ab785f4cbe1a978a74bef5b109e78cc14768735f33a1c4573"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2edf7cefe64b2e344ae4d7eb2b7a96c36c39bb15b0cd57d8071159be5198476"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb9ff5b7e52ebfadfcc23e704a9c37dac49e61d9ac061b5f547e0130cdbfd094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d45a1f440577fc2eb3f764f2c0ef8a1359bad7829e25fee6aa628e37f3259bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "72ad1e0090b0c9f9618a5228c305b92a6b89afcc13d7770ff98e3664d222bb7d"
    sha256 cellar: :any_skip_relocation, ventura:        "18393596bd83903c35ffcce1b16548383a79e3b587c57355de3df0970dda0fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "445650e739fe7158046d812b89a57143414e18992617c03d8d0b0b44e6ba25e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79033eb909c5ccb924e9a12ec8794b3bc12280c4e7c8a45d07d5860018e10741"
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
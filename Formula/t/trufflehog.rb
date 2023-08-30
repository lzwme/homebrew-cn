class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.54.0.tar.gz"
  sha256 "82391b2845e1c64e63e52a035c162e650a3f94ab57a327e4d76e66a1bc9ac4a9"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c873adb194004a83f70c505f4248920852ee848919e6f35e60342d7b0a3f845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6540b131dac985d00b4bdbfac3fb2882aaabf1cf6a33269bd60b5c5568e5cdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07edb515ede4804f00ee48db8537426519b41fba9e3811298eb5d2b5547e92a4"
    sha256 cellar: :any_skip_relocation, ventura:        "4bd451e492418f586f5e163deca84f2e9d6f896e0b0c5a67f447ea0d5d03e2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "774958a746f25f75a88ae002173fed8d5e3942bb14eb85b99c603ab18c125511"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f3e43a6c72fa8aa2e5cf9f20b2a483f336dbd059f07e0570630c067ddfd6645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09f696149aa8fbc5feb726356ca17a1d649d1b8151c7b3b498b9b47ab8a55f8"
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
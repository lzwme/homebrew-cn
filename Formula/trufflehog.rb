class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.47.0.tar.gz"
  sha256 "0c559e87654345b9866bf1e9f3618699428144cf645e390defc239ff8f1abf63"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c34f1ac7ade3b58abbbc3db7f34ad88da25d040d658be8117d7a759109e576ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6625d92cd5cd291338f7fcdd886b1a9e6106f9f203fdc7a85dec1a2154136f2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "752c6c344037ba2a809e1da6ce438b2571845979c30af7cf6eac0f57e88e6cc5"
    sha256 cellar: :any_skip_relocation, ventura:        "4e09acab39d829189c58aed48465f9f3e9c23a56cede342d9b2ba96e39f82c25"
    sha256 cellar: :any_skip_relocation, monterey:       "e1014ed4c5f2cb21d5a4f7d5bad537acd4b21740a48ac6bb9e6cce1e525beac0"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb83ee17caded4fe7460851cd0deb4728eb09fe339181c5b1977e3f678ae337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233e5c62c222f1ade66dd2533736d2d301e999297289883ec18e00764681e5c6"
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
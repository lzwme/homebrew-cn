class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.46.1.tar.gz"
  sha256 "d2022fb09bdb142cb35bc41eddcd9cd0de325ad7eba2f271f372112b0a6b4a9d"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d95261840a806d796c708ef057a82c134fadaec60244942c65762ceae0bd77f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d66e39431611d986f3e2cc59eaf0fcf5b4e2cb0076d36d1c223374d6f225894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ec1306df3425d799b0736492405ec0c40c26713e8cf8848c88fab6ef48b648"
    sha256 cellar: :any_skip_relocation, ventura:        "508bc4104c5cfde40d021a1e9c4a4a3ee8ddc3649676ef4d36bb6dce90b9c4d4"
    sha256 cellar: :any_skip_relocation, monterey:       "2846a8409af6c80860b5631b0b1a4d7384bc1308510bb42ba3f2fd47fb511eba"
    sha256 cellar: :any_skip_relocation, big_sur:        "836c20c316450da72ff1158ef19b47176fd079d0ed2807043c7640b4a5f09dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae29bb31e1cdbd09e4e9592a3827e0924aa1492311e7b18b1df583954fc0d4bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0}"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
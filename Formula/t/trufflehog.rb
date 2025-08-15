class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.5.tar.gz"
  sha256 "cfce5732c621fc096240d825c4d063b5d4c35a19340887b89471929ba737063e"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d735ef84e89a723bdd9b051a3e392c0c8adfb523e43aace4883cb9f8105dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c57dc917e46e3dbae47cfb45a6768bc2cfa598e6d66e1cd9871569ac5c5a8dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e88e19edbf552c2d8b95477b434e73c44d5668f606031437e22e55c7701ad8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7e756f4c3bacc802d185eb8f0cc22a9fe7b82d529b3d09ca0764d605a314e96"
    sha256 cellar: :any_skip_relocation, ventura:       "2086134066d87258a1b4dd8ebcfa685ccae87f185bd5eb0debf70b508d1a24f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bfd80df1abca921dcdafdedfc08a6c61378d2fafee94791df902d55c8aea8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1c53fb2654e0befdc1cf4a669274063feaf06c5145227de47604a388bdc950"
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
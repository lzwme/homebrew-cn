class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.5.tar.gz"
  sha256 "0a0bf6c70e0e8df76accc9358d6e015a820d79708cb053c47602e96af124d6ce"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8738cd0f621a7acb58401fbf17a7cdc6579af89dbfcbb2b6c4a74c307baa84e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e4041b1057a9ffb1e90719e3e1faf0d1182597d92e497face83f3d3a51900c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69e655a54f6a3eaab36ddd958bf86cf7bc5100cfd0c72dd723afd46eb871eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1ad2b615430916e42951722e8c5d004a58deb92963f66b9418c42eb5c0213b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "804ffe502b1e57e6346a75f94fcb207d9a5fa989782608d0edf477b249335470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce994594e2517340986c8fd0c8da93ab4ab892705aa19a693cb02b4a70bab0d7"
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
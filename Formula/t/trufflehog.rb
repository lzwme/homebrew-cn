class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.60.3.tar.gz"
  sha256 "f89023b0adb03e00c5e2ba72c0a20ae9e52a5c85ef65df690ef336553f167505"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "016d7f63b520ae093afb36c874b47340a1bce6fc232d56a19bc057fccecb59b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57f0ae340d8eccad055361387742503360c78f4ac194e3f9f715da4af6a6179d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "686a58077eb2ecee5df9d9c861f61afabd53f4bcf37519543e5c01668456acd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f41cab1b71fc14357709b3af72b4afd7a3b7594c7686996a16b2cbe136dc25f1"
    sha256 cellar: :any_skip_relocation, ventura:        "05147c35364ee5ddc15deb0fc58f3bb3566369c09adb3581627eda253081ab2e"
    sha256 cellar: :any_skip_relocation, monterey:       "fd3bb92d805b21fe0f7d6f0673ee2545e02612c2b071e700789583dcf2b6f5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1edc83d7ded4fe9f0b6b884afa82bcfb1334f4f41c42446c8eb267254a07d3"
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
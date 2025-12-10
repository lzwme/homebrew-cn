class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.92.1.tar.gz"
  sha256 "c2356ca8bc293228bd900f524470d6c7b94fdc50f300e584b7a1233a2b298a1b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec2bed88983d328a5c5008ddce0a12ad96c79568def2865590ecae2f7bf12c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc93f2b270bdbb648c6f873fe3531ac72712bc812ab405578c4e9961fce6e552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe2d5fae1dc6a0aad0cb73c1de5530ad8db43eaa70254028d9d2c28096ceb65"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d5ce547a1a5d304ba4b26e711f1f5a4636979a5c06f3caf6b12b395b0b0059d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e130fbe2d01e8651dadf52d8d89df21bd18ce9021c15dde9217b064d3bdc29ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "800c64974eb94284710366aef94b77853932e4cc38ed99bd39460211da82ea3e"
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
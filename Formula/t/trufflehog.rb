class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.63.3.tar.gz"
  sha256 "0b0c350f99bc82df75988ca1865ba70b297e765b5d197b8e7f014a15d335def6"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90765751634b86d9fcfd74b9d8a41c87629eac3883a4e46c52fe95a1bb310cf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b037e1d377aa484fecfdbf9e10c5923b1be78cabe3a4d4d5e9fba02bb47398d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36872b45dee74b496b7d0b4d46cb3cb293cfc1923d9f708a0af1f0d244132eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "10526577887828adca3434ff02b8b8a85cbc013ed056d67cb138597b110e33b4"
    sha256 cellar: :any_skip_relocation, ventura:        "ee36be63f5cd5ebe551ee30f1fec49c9ab5a0cb1e2b1cf983e45b3435b00887c"
    sha256 cellar: :any_skip_relocation, monterey:       "3d27cbe4abb4ca8ecedb005f6aa6a733b5a445be4c21ab8b6c4a4cc0f01fd7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3001c678cd28677963ff713fe3e6e8aa50cf139036c021011e405ac1c41d65"
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
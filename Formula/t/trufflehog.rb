class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.2.tar.gz"
  sha256 "f862aa0e1feab966c0c53858fe3b514804039971882d26de53684ecf88f926f8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7460127df9aaa095e009f3fa50a54eaee008a840c77e07e87e7237d6591245bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2235599af5d0d0b51348055b1645961b7a0820e004243b5b8b3b3b1fa25db319"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29cfbb2c60912779f0ac35b3a7b03842d578ded0a92d264f597e4775728206eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8b68709981f5a1df6fc1e923c095f45bfd1d17e07b0d6deb996992c5c78a6e"
    sha256 cellar: :any_skip_relocation, ventura:       "9b8225bf034676f72751574fd6db670d4b4a35d381bd5332629701447c412bb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "162e718793943c53baf2d1737b6cc5ea9e9bd57022e286689a1b8ff1db5db585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb28c8d7c6a63021e68b971391d609547e59ed144c14bfe051105129905a191c"
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
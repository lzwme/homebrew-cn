class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.6.tar.gz"
  sha256 "3a19686c5d7a4492e7e5a56fd940d91400791c8205a582c296aaf68c5e65ccbe"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f80dc8c4da2f07e323cded941f40e2f9fd35c5ac11acbbde1c30566d1f9768a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "def6c02292bf491131923951b2bbd217165cc0caaebea726a5f34ad327a7561d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27681c72079de1e1788fba97077db538bce5296ee466382673fc458c4a76c66c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb34836d51bd620edd7b6f4106ce8c3a00461c0eabaa10df53d23839775b0a31"
    sha256 cellar: :any,                 x86_64_linux:      "d31ed3ec6cb154fc997d1bbd57916caa487b9da636776507aa96c0d16cc7ffcc"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
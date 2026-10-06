class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.98.0.tar.gz"
  sha256 "7411534ce8a6c69cbc7cdd69be7fe0fe4ff26aa6c460152cea67144bf236aae3"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "445a0d086955f90836cb26f289732abf61e80e1403c61bb7732b6266573955a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b26b3c7d5cb3b006c655399523d975f53a4c57ce4ebcd6b690104f821ce53c51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7107b4f992a568b240e8f6e58f4e8e9d7235d4ff4ab13038de718945fb063e2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef2898644821d35ad11f10bbd2db6a1376f890fa69a72079f3e9f2f1b0c9fde3"
    sha256 cellar: :any,                 x86_64_linux:      "dbc0559f25393a1e7229253461c0fee7281dab42feca5d5403555c7ce89c1f06"
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
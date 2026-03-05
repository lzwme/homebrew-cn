class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.7.tar.gz"
  sha256 "7d879582a1ddfb56c7dc9193ad2c416478a2310b9d942a127bf52f8b36a87c75"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77f2381cd18e1a83d514e9d8bf7a6bd75812b9a8f56d60703b28c6b7cbed4813"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdcd19f9c85ab079debf92c917bd6557ffd1dce22b5403985b49b8d63d68f5c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1ecf820e98ced4dc7ce324eacdb8ec1192effa7407e140c33bc935e76d46c6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "16cf515a8fabdf574367b45ecd24546ce2dcee0b38412e4c6316cbdff65d5adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdaddb1022ad1e4b8065a907427e858e47d059ee8a373d8b34b1aef7917378e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33896ca2e69bda1b7be61ec8ea01a3d13600a72f192a6e0b59a7c64e9940ecdd"
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
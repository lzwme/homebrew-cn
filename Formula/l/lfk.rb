class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "64155c906096679b19f0e6e198c7b57409fe398a126dcf22dd5f771fa767c95d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "502a0750d042159923ac79a75a1d1198c96b9b3ae09a499a21a4da335852ea71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "502a0750d042159923ac79a75a1d1198c96b9b3ae09a499a21a4da335852ea71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "502a0750d042159923ac79a75a1d1198c96b9b3ae09a499a21a4da335852ea71"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e83e3bc9c6242831ad3ce1811bddf52d843bb3455a52c6316b5a047ca4fed8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "eab5a1bf423f56d6958644f2886bfdb31aefc5b4b76a2c8841358b93e1be467c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
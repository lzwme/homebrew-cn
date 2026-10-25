class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://ghfast.top/https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.10.24.1.tar.gz"
  sha256 "136e83d08cdadc913a49ba5e16a214fa064953d57a7d215e183b9c30abdcf81e"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d35d2d01f5b50cfb8949a70a9ec483b90920ec60ece303d0298a13c81214ee2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d35d2d01f5b50cfb8949a70a9ec483b90920ec60ece303d0298a13c81214ee2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d35d2d01f5b50cfb8949a70a9ec483b90920ec60ece303d0298a13c81214ee2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a916ef01ca7822be843ee1362295fb5e48c8863ae52738e42db54610c2fd220"
    sha256 cellar: :any,                 x86_64_linux:      "10e004cba71d75bbfcb1067d4925f25b0857655cf293391da610a012f718ca4f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end
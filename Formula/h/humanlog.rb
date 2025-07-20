class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://ghfast.top/https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "2013718739bba58aab570e73bc8b21484e0e0ea9f6c7246d5e42cddee70a3c73"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10053be5b2f6fe186e9b13ef300b2155c910da71bc873b1d7d14bbc20370635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b2c32d9515b7c974e54e37867dcf96e3a88c9ae091483994e0ed5a196d148b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea11a9b1ec4280246e9790f7bd7ceabb302019dda5f6a2bdf457996e85eb4376"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f177ca7528ddb850d75984a28e5e4d8edc2bb21b0412584a0a8ccba34328c1"
    sha256 cellar: :any_skip_relocation, ventura:       "79b8e40665f3fc23f8a0f6ca4110dcef8d9d8ebd06b63e8b2aec0617bc31a693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abfce62bb36d5bdadc5857feeeec38b842ad3a1fc402b9baf4479c8666cc2172"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/humanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin/"humanlog", test_input)
    assert_match expected_output, output
  end
end
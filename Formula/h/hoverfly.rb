class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://ghfast.top/https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.13.tar.gz"
  sha256 "9ac6341258bcd5455aa0e3d95db867d842b37178663d922952b2f60e30b1b641"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "879321f59e6851fc404c27904a73954fac5cedee3d2b5ef3a83cb4ab76ec034e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b61437e2d19100c78d60849db6e598713819dbbe03ce4cb0790c272f70fad55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b61437e2d19100c78d60849db6e598713819dbbe03ce4cb0790c272f70fad55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9b61437e2d19100c78d60849db6e598713819dbbe03ce4cb0790c272f70fad55"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49bcaf02865fce61f91706fcee016905a04c6bd762c3ac030cc79d6ae2c6075a"
    sha256 cellar: :any,                 x86_64_linux:      "279e0b5fb26e5dd3cfa7a4145ad592a13355bb9e62c7e0bd6a2bc1ca1902803c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
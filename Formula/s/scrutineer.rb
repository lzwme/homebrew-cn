class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://ghfast.top/https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.09.26.1.tar.gz"
  sha256 "62227311efe1f547831ee31b597bfd0b469832382a93fad72d779c46d5e8b499"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c9790b8e0e1205c3d423371fc5c3d7782106c0fbea3646113bab65808f69021"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c9790b8e0e1205c3d423371fc5c3d7782106c0fbea3646113bab65808f69021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c9790b8e0e1205c3d423371fc5c3d7782106c0fbea3646113bab65808f69021"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "28bb14dda9b4ec44cf9b9785aadc9b55d291889afe3c5538d9f7f4fe47608eba"
    sha256 cellar: :any,                 x86_64_linux:      "633917d3916b8540dee090451301566203bd5dbc110c70cd44b566e49ff2f9b2"
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
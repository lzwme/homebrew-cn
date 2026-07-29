class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://ghfast.top/https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.07.28.1.tar.gz"
  sha256 "407d3f5893d323bfa47898ef5edfa5c90f3b38bb49154f61fead9c5889f62b65"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c64c2a55385d0e163a26dcdde47f299caa07cc69a60ba0992e4367f7f6d4d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c64c2a55385d0e163a26dcdde47f299caa07cc69a60ba0992e4367f7f6d4d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c64c2a55385d0e163a26dcdde47f299caa07cc69a60ba0992e4367f7f6d4d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "61a440fb8b67844f3c949c7317b7e6f39eb552bbf2229c27deba4d9a9b1cc482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb29456e4961ed33bfa58881d3afcb63708ccdf0cae2c7dfd5941b7903220aaa"
    sha256 cellar: :any,                 x86_64_linux:  "a0ff00d249d96d7a7c8b7b594628db041f5aac56112803e029b9b074345bdb9a"
  end

  depends_on "go" => :build

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
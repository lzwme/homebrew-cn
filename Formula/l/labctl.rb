class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "867c943d981e3e87e634a5a86c4afe9477274cce1068e312210c5e86015b2017"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7797d2c0255d9c1a4e7c3b89fa1ab79b9a7de63e8c65a2fe369dd871f2057ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7797d2c0255d9c1a4e7c3b89fa1ab79b9a7de63e8c65a2fe369dd871f2057ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7797d2c0255d9c1a4e7c3b89fa1ab79b9a7de63e8c65a2fe369dd871f2057ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd5f69c74e6d175844a80564b986c3df4ff35cf00c36c818e13813e93167ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b870f1e0dec7c4efdeb49371e70ea93237df8dddec79b1b43712fce160b1cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94843b20e1011da68c8ec57a083b952fa510114f6359c90c97c2d3860f77bb06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
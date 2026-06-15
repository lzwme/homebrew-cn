class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.86.tar.gz"
  sha256 "96eda5c03ccb9eab6f3715863f71cbe6aaa05ea653195e3ad93533ead850cc30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "052d2cd2c75b6964fddcb782804059154218263026f78c882a20b9b294d41c34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "052d2cd2c75b6964fddcb782804059154218263026f78c882a20b9b294d41c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052d2cd2c75b6964fddcb782804059154218263026f78c882a20b9b294d41c34"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9b8260f8a75d0460b43e08819f5919154f0abbeeb7ea4c4175f7f41dc5bd4c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c528a8a691e0704bf703304063980873e9f510ac3b74618ed232d7717c03ebf"
    sha256 cellar: :any,                 x86_64_linux:  "dcfca935f1dcd978f24aaef8f2d024102bbef0ea9ce52de68504a4113114e256"
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
class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://ghfast.top/https://github.com/s0rg/decompose/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "6f88e3b6a43bc3c67dd8e9a2414b77e31bdedbdfe4ba5dc963a5d2def59118ea"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a7b8c8d0a57e0b888cb54c22ce59bfb41b54a3ad1281c45c5f4b31d54b77879"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a7b8c8d0a57e0b888cb54c22ce59bfb41b54a3ad1281c45c5f4b31d54b77879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a7b8c8d0a57e0b888cb54c22ce59bfb41b54a3ad1281c45c5f4b31d54b77879"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e8bc340f8cf8c3744c7af424229bec5380082e86728ff786554493a5ee135c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30e4272c29ca35025bb56ac6aacfc590d1b9959f7c8671609c182b5e224a6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "479260b2215a5278c15790c6ba097672c92ba722e33b9de8189db91dacc064e8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end
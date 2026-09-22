class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://ghfast.top/https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.15.tar.gz"
  sha256 "3ac7c620995afb5b8bf08d35601f0c300b99911e4c1a43b301e291e82b242066"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06c9ecef74d8dfec3a1de1c885eee978ecbe885745f42075b0c894955104f9c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06c9ecef74d8dfec3a1de1c885eee978ecbe885745f42075b0c894955104f9c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06c9ecef74d8dfec3a1de1c885eee978ecbe885745f42075b0c894955104f9c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a76e4069f69c7576a25742a15863295e03513f6327b5d3b3485a9805d17c02a8"
    sha256 cellar: :any,                 x86_64_linux:      "aab45128229d84d926e266dc82cd00d5646cff945e7a0c7003778a0042864d22"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
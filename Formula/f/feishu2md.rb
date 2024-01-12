class Feishu2md < Formula
  desc "Convert feishularksuite documents to markdown"
  homepage "https:github.comWsinefeishu2md"
  url "https:github.comWsinefeishu2mdarchiverefstagsv2.1.0.tar.gz"
  sha256 "4cc533676d99551f08f75f054bcb3694f2ae8ca29839818cd34471241a88828b"
  license "MIT"
  head "https:github.comWsinefeishu2md.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e3a39854a7462d7fcd49da3f2adae99d906116df6fb0ca8800a3e42de2009e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe2c279f015887cd2fd40cad424582e8afee5896791e5d0beacfd1448562782e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "589f7fcf13283586e0429b2ebd969bd6309f4f37eecfa7574c9c3d3454b3a33b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7984382f12251ef6ec8d1d03dbe124c1c70365726c3bc008cd7105d3d0b05f7e"
    sha256 cellar: :any_skip_relocation, ventura:        "9541ccf931f5f7449954d6b58fd63afa40c28f354154979370fef1b3a00d9d22"
    sha256 cellar: :any_skip_relocation, monterey:       "03e90b0b1e64f90620f7604e6cb84fd65f3f98915cc2673d5e9f1122185e8fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059ef25dddcf93ed07886dde8b8c18c309625608cfb39f6026ace6d92de3290f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmd"
  end

  test do
    output = shell_output("#{bin}feishu2md config --appId testAppId --appSecret testSecret")
    assert_match "testAppId", output

    assert_match version.to_s, shell_output("#{bin}feishu2md --version")
  end
end
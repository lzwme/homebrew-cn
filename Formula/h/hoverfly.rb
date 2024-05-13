class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.9.3.tar.gz"
  sha256 "a5b43147794fd3896e56f08d0ae976d9124b8a02880846f482cd944aec3f1589"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48351e5c70b8f81e83cfe3a5c57fe5220ec33b96cdf0944e7788f638efe9519c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "320db4282c85b2151ac4ac460ecb2b1311da25375b894ca1805d7a2a2a446521"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d7125dc3a0196324a7d2d60aef7d64d3786d7d009611b281cc245aead650c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a87a1a7f6f488522564b8a139646a5f862248a188aac0ae5bedd29265857b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "dbdbce2429f2fbb90457af5c0781988bfba26b6d8c08eb543cc53c62d33583bc"
    sha256 cellar: :any_skip_relocation, monterey:       "2e99d92c829cbdb8fed3d026cde8e20e3ef3a675000ab6cf171e6d47a4512b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d5be9ec69175a90b6e351f993c3b984e28c1db36cc9dea2ffd1753c7fbff51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".corecmdhoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}hoverfly -version")
  end
end
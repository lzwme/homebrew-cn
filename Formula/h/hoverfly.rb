class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.11.tar.gz"
  sha256 "ecc329f174a2df9d2806e0a10a0ee4c418a787a6f8b7ff24ab2e4b5c3cb67c84"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f37454874a10628448623e4f8104a3d0cd53659f09aca4d70c96c7aa5208a03d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f37454874a10628448623e4f8104a3d0cd53659f09aca4d70c96c7aa5208a03d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f37454874a10628448623e4f8104a3d0cd53659f09aca4d70c96c7aa5208a03d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5fab15e2b1583fe3c64c8d0e224ea478e3e812f44a8562bb5abe8e3e15291ce"
    sha256 cellar: :any_skip_relocation, ventura:       "d5fab15e2b1583fe3c64c8d0e224ea478e3e812f44a8562bb5abe8e3e15291ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3359c96b1bd06dc60990350115f2342478e7b39e7cb864a968bb24909baf8b7e"
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
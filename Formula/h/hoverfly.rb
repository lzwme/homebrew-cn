class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.0.tar.gz"
  sha256 "0bf9dd06f272d33aaeec5da70f4a65d6367e3f894082865423f56cc73ad9c0a2"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a995cc926d215673d0327ad59f825e9ec3523fc88347d487ccb8765f82fc02a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e929757a50642d31d2b470619a0206c1396cfd3945b724bb0152bd21502b2c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f4de4004c1ac5b6a5856118c066455bf847f0921863b3d29dde52fa5ed05e84"
    sha256 cellar: :any_skip_relocation, sonoma:         "f715177d954d92d9ab8921f25e5c6737cc84417c553fa3351fc9df040d7f8786"
    sha256 cellar: :any_skip_relocation, ventura:        "ac255bab68ee2134575913c5fb571bdedb5071c701af025adcf7dc2d8ea3ea20"
    sha256 cellar: :any_skip_relocation, monterey:       "30f0df697864ca50a502414e65d8dca019e55ad186c5c8ab8c5ecbffef37ad4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba693a3606d8cd1a1a27344018ec7557f009b2bf1fd1e61828be2a6c7d0cbb7"
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
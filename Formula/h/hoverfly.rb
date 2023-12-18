class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.6.1.tar.gz"
  sha256 "b7bbe28c5d5c2449c46232b7985b0c08b76295ace5b57c0e27d4f9ff60dfe83d"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12370c49cc13b5e51e0f427a3f1459d12ac93647064cc9a4c9465a178aef89b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56f3bb77adea209d2f09ec1a398e515cf1690ed542d22cdffca9d8a863d3d7f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab9c9018281690524aff250fc37d7ea8046c4a745d003a8a115ac61bc769c851"
    sha256 cellar: :any_skip_relocation, sonoma:         "1817308c9b3e17904effff88fa047426903c0bfe420c58c9fa2e520ad2cbf162"
    sha256 cellar: :any_skip_relocation, ventura:        "6ae51d97e757d2bfe4144764905befe48f79b606cd246107c4c8c3af20f58e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "abd5732d3e0e248c1e87f1d4bfc2543f634732ad5da59ffdd227856d369f0a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96228f3c11ddf8ea99fb29b4529faf9e33758323389fb555db648eb289e0d57"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".corecmdhoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}hoverfly -version")
  end
end
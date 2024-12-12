class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.6.tar.gz"
  sha256 "116755ae5ac7af9c2a63ee2ab9b8fb26fe451af4722f26f95121de240167acd6"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ef5a96a32a9054e279df80d8f73d351006bc92cac65f374d41bbc46524c9c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09ef5a96a32a9054e279df80d8f73d351006bc92cac65f374d41bbc46524c9c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09ef5a96a32a9054e279df80d8f73d351006bc92cac65f374d41bbc46524c9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed2af5c9928bc65af2a929de43802ac05b945b577546ea1b170db69c4401413"
    sha256 cellar: :any_skip_relocation, ventura:       "0ed2af5c9928bc65af2a929de43802ac05b945b577546ea1b170db69c4401413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca4b54faf15197160f0f0dad4814b409ab6c6f85022f8fd810d7522b34876fb"
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
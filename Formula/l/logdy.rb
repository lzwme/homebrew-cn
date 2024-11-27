class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.13.2.tar.gz"
  sha256 "06f4061f9bf676b0b3125ed7fd4fc4a38b6472958bfb162a1cfc0266eb2d0d3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bcebab22e2c35e00d15a5d2d260a3edcc056c373259feb81934832cb325d96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29bcebab22e2c35e00d15a5d2d260a3edcc056c373259feb81934832cb325d96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29bcebab22e2c35e00d15a5d2d260a3edcc056c373259feb81934832cb325d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ea0519660476e0ff643bf4383ebdefeb1ef2e748490c848aada6e7428b07cd"
    sha256 cellar: :any_skip_relocation, ventura:       "45ea0519660476e0ff643bf4383ebdefeb1ef2e748490c848aada6e7428b07cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725b23e72978089bf5a790f75169b806fb0e78a95130b77b4535d13d7928db4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
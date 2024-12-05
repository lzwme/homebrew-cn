class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.13.2.tar.gz"
  sha256 "06f4061f9bf676b0b3125ed7fd4fc4a38b6472958bfb162a1cfc0266eb2d0d3d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de0e9d25df46912c32bfdc96eb8e6da93d5e1f9dacfa49996a8403f9c2d7f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4de0e9d25df46912c32bfdc96eb8e6da93d5e1f9dacfa49996a8403f9c2d7f62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4de0e9d25df46912c32bfdc96eb8e6da93d5e1f9dacfa49996a8403f9c2d7f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "077b1f7d9bd81574b65b37fe721b6f5469a646ba106231aeb49457f91d1cad87"
    sha256 cellar: :any_skip_relocation, ventura:       "077b1f7d9bd81574b65b37fe721b6f5469a646ba106231aeb49457f91d1cad87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17ae0320fa5f2272e400b2e7babed6dabeccd9dde7967adb6c619de8eca178c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"logdy", "completion")
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
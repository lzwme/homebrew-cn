class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https:logdy.dev"
  url "https:github.comlogdyhqlogdy-corearchiverefstagsv0.15.0.tar.gz"
  sha256 "93ac3553c8d3bfa2dade1a5225a6f13d3ea99a8e45caec461228d6f16a6b2a87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbcfbae136eb16ed1e4de10ac79e0f5dcc2dc7db9d9ec79607bf2341a16af843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbcfbae136eb16ed1e4de10ac79e0f5dcc2dc7db9d9ec79607bf2341a16af843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbcfbae136eb16ed1e4de10ac79e0f5dcc2dc7db9d9ec79607bf2341a16af843"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6cda80ebfea7f1861958465142cac25010262708d8244a628dd1f32161a704a"
    sha256 cellar: :any_skip_relocation, ventura:       "b6cda80ebfea7f1861958465142cac25010262708d8244a628dd1f32161a704a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61d337aefb70cc014f1a96090f4f3a3224519f8d517abd104571fa42564959b"
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
class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "93b862ca0feb28bc19c70535677ce2cf2c4118b37b93a5e17d64984d749a1283"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee81f9a93e794798c81063d450c364fd3303f400f32c9ff2f5c640f60b45ee23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee81f9a93e794798c81063d450c364fd3303f400f32c9ff2f5c640f60b45ee23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee81f9a93e794798c81063d450c364fd3303f400f32c9ff2f5c640f60b45ee23"
    sha256 cellar: :any_skip_relocation, sonoma:        "4008e2018dd045c097aa882a778c925b013325a8eec974112bed3a2826fa9145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccb37cd4526a91511d6902c1aaccbbf4bf1724362a86d7aef69a70dced2c8e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394dfa283a273480cfa969f9f388e33574bb232e3275f796f890c3419a3f693c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://ghfast.top/https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "cfacbfbdde3dcf732cd588162af7ceab504464ff2988c8811a6bcc5d6e00d23a"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8105dec9a4e6592658ed70715c9bf39fa627638e49c9a4fdaeb88e3d448f7e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8105dec9a4e6592658ed70715c9bf39fa627638e49c9a4fdaeb88e3d448f7e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8105dec9a4e6592658ed70715c9bf39fa627638e49c9a4fdaeb88e3d448f7e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a804e24fbb791d0f7afd2172807913bf51f923f6049bd88c74f3658a12960f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd59c5d77f1a66d4a0ae794a349dd4fd005fba52c7f06a6f09c41e3523fc8c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be40195c6f2f0fbdc6415ca3469e853a8368c3fa72234f96f6a2312a084ba1e"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/cmd/picoclaw/internal.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENTS.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end
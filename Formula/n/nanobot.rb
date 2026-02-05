class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.52.tar.gz"
  sha256 "b6571151900da1a8f72ce65cf3eaa06126d16ab1c4a84847c4b5906ae01910fa"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c21b75b04821d893b9cca970f5c4ef0726440f46f4bed990ddc04d2d0a933bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c21b75b04821d893b9cca970f5c4ef0726440f46f4bed990ddc04d2d0a933bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c21b75b04821d893b9cca970f5c4ef0726440f46f4bed990ddc04d2d0a933bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3693c0a6e3ba19fbed6acb9f510f815ae5ee13238902edb762af0187335e49f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5584cbec1ecf430c20501807f29eb9dab6c52388a28a17e24606fe3dc754b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0163bb1cffc9e6ee0b15509dd581b50acfc2f41dbdcb50ca4e71ecf86ec36ea6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
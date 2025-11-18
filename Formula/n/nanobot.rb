class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.33.tar.gz"
  sha256 "29394e0988c1b9bc11dfdf445bf89bdfecf5c5c41962bd6ced536878b78da4e1"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fed785eaa91aa2a6d0fa8735834fa78bbaafb36f2a36d25eb3cbc8ce1f83c590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "533e33e4afeda5da77fdb58ee2e61b87a128f74d73d8e3ce23d00e3b020eafe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bae37084d9d698c4248514739ff8b88fb5d943167ecf6f0d0c8c2cde5675304"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd235f9018f646cb70cccac5d3ec99a3a5a8611bbfedd90c12a4b4fd91868a91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0fa42baf4257b9c45298577908548212aaa81c8f693d3b3bb3f2584f7771bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb91c7610c94c06a71efa50a4c685ca5a5ff483a5ba5c46d083eb097b587c3df"
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
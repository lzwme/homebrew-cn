class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "38ab35d92558fd5a2db95816f04380277a27071be933b28a924d7aaea6281192"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63de84dc96437a7ba72039ac2df924b97fcbb630b40602dbd39d66037c317534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63de84dc96437a7ba72039ac2df924b97fcbb630b40602dbd39d66037c317534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63de84dc96437a7ba72039ac2df924b97fcbb630b40602dbd39d66037c317534"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea96423631b0636dee67a8b78a3ec723c42a066ae3e2d5ac9a0e78415825f0e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ab98415f0fdd01621a17c5c984aa8fb3ba1efff5939d568594b26ec0bde6aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f8d81dfbbec020151e0788fd0ab85debdddb39d61518f35f0e3c5e212b8cbb"
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
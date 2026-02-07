class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.55.tar.gz"
  sha256 "f7750dfcd943573c4ae30046879b4a3290b3bdba510e941c4490ea2e82c8282d"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba50a525ba2ba96fa295efc77adfe37a2373b7be9c93a5f91276034efa60396c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba50a525ba2ba96fa295efc77adfe37a2373b7be9c93a5f91276034efa60396c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba50a525ba2ba96fa295efc77adfe37a2373b7be9c93a5f91276034efa60396c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac7e2a908cf03f968afb5d360bfb30b3bbe5928dee6b9de7d8fc10e3eda1dfc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "762c2b9d356719cfd6ab5dfa50421f6c280ec4c0c1d033c974a73117c80605eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f8a04410904ba96ce9daa5241aa4dc511879c3b9e67ed7f0050ee04ba492900"
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
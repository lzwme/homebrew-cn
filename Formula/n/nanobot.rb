class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.83.tar.gz"
  sha256 "29a02f75e7b86a70b7cc101f4283be28fa93f6860bf1234990699a42ad47dbfe"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b1d4a6fea6e7dfbfd19ededd7d7c1ea04e18783be933a08123b0b1981a37a3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "342083f209eac3d734f8d902516bde76409755d789e486a4f9684a6b8c809b32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef82ed26ae7621b734079ce7973cca6de45d8b1ef931dd7a471e880197ea174"
    sha256 cellar: :any_skip_relocation, sonoma:        "602f40553787de3efde411dea84ee7625c5919122809364b5555fc98e1427c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a714850e4f45aa20282fee3cd246c76cdb4498a2a98a47656b4e0b8d895060d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bceeed5f4af1fcc85bd7c5047225beeb505828e7e07094390ddef9704ba57000"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/obot-platform/nanobot/pkg/version.Tag=v#{version}
      -X github.com/obot-platform/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
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
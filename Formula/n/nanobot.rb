class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.81.tar.gz"
  sha256 "697434d6612f2afb9e490d24530024fc2771065d4130f1a40c9c7939b76254d4"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2815472ff13e5c28aa33ebbb935da9138903447b2764796cc18d54a738f90f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2705f595018db591a589603516dd9cf498d3fa31b200c9b35831ba1be6e1c861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cac50e35c77e51071d91e783fa4b6d7b30e9168ab9e499ba84ee4d53fcf4497"
    sha256 cellar: :any_skip_relocation, sonoma:        "48734f94715cfe45f9f0caed91d053391f3055e4b3f32a5fe9a14f6f2de2c290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa80438339090f2dbe2905b5823b6e721a3c242e5851e4dbc0a0661cb4760154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725ab0ea91154fedfa65002657056a90d7258b9c869eb6458512f2a889b00ba8"
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
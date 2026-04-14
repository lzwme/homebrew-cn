class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.65.tar.gz"
  sha256 "647ffc7ef7476d90ef0249a45faf15d542740ec90705e85b66075dcc7e9302f2"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beb1cc38636f0ef8df2d89674ae8b0fee984619df96881cfa4d4d883b22bcb67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41708542bd634852b80f1477d0ee8e87cff9b3ce4d8105807a80e40c8d8c6c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b762ed01b4ca4b5913c1181ad5169bdc0f4ea9701184bdeb76975184d921bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ff83461227afcdba23bea8cb3fcde3412ecd81e21f721d94dc7d0edbd6f8ff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8089aa25a88841c07d24295bf34519a93ad9d8722e73bd2d14e2a1074105fb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72fc55c1d17ebaa0bca6ed28c550fa798e44da465dea24e5299fbae1f736ea85"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
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
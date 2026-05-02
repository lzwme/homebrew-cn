class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://ghfast.top/https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.77.tar.gz"
  sha256 "c3b7ac926addaf1556f33dc383e10f0082699effa453ad27d9437218d139c3d8"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b17a9cc0496f093f968b7f3adf152c48c0afd948c23ffcb8b51595855a7ccea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80c5d1e7f9e43a42c561299d3c898559132300b0b9df213738c400a66c531949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac857b262f4a29acf5737e15700a94f630f1e04b42ee6ddd648ba143671f535b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0acaede009975af3334e3d9ecfbc674b4cc828cbc594ffb3fc03a872d06de32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbc66ba594aa6806e54e3483e9a08474de6067eb46be0943769a8a7a681ba79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf534d12119f9638e93749e11007d0b880eaa31208601cb205826e9b8e06fdbd"
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
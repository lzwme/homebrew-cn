class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://ghfast.top/https://github.com/1broseidon/ketch/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "e493e64e8b0da049faea10e831c41964c8005c965ef3b5f74a58b247b171b227"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91772c0015f7a9edd2cad12f370c133ac29cabf359fe649cee7b05804f1827d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91772c0015f7a9edd2cad12f370c133ac29cabf359fe649cee7b05804f1827d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91772c0015f7a9edd2cad12f370c133ac29cabf359fe649cee7b05804f1827d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7360a21881be40d6da7868ee86488fe0d870085863fd6b32ca38a0f9d3808339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f22aeccae661b941a4ee5b3407bc19c0f26b16f8f4377617ebe19eccdc79f0a5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/1broseidon/ketch/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ketch", shell_parameter_format: :cobra)
  end

  test do
    ENV["KETCH_NO_UPDATE_NOTIFIER"] = "1"
    html = <<~HTML
      <html>
        <head><title>Ketch extraction test</title></head>
      </html>
    HTML
    result = JSON.parse(pipe_output("#{bin}/ketch extract --json", html, 0))
    assert_equal "Ketch extraction test", result.fetch("title")
    assert_match version.to_s, shell_output("#{bin}/ketch --version")
  end
end
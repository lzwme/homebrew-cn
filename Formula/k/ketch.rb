class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://ghfast.top/https://github.com/1broseidon/ketch/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "bb566506574775622fa233f0f000df9dc0603abc3b87808722f5dd4d7befeb44"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd380146b84210b801ce8589e08dd0762d83bfa1155f48af6bab20a5706178be"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd380146b84210b801ce8589e08dd0762d83bfa1155f48af6bab20a5706178be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd380146b84210b801ce8589e08dd0762d83bfa1155f48af6bab20a5706178be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f2ec491ad6625795fda9097014f466b07450cb5483f14bbd756851791b46badb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1706401b21d32e69ecb085959a8118ae02526a599f77cd0f664cd186266bb291"
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
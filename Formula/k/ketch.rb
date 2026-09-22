class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://ghfast.top/https://github.com/1broseidon/ketch/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f7feb8fe0b9f66933ec45f8e0e753d5d32a8b31cb1855d32f9a5ba3bd8e7e8a2"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16a9f1210abc127082ec16cf245d03cca25b8fbbde3a92a87fe201c955ea7273"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16a9f1210abc127082ec16cf245d03cca25b8fbbde3a92a87fe201c955ea7273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16a9f1210abc127082ec16cf245d03cca25b8fbbde3a92a87fe201c955ea7273"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8803dd4c341f0153024949e4d712883e9f22bfa4ef0afb1ffb11f921edf8bef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad1a25628dd630dd94855c31d9d696c5e18eb71ece3c9a7623529f0567b3b981"
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
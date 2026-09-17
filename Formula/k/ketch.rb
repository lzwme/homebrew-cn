class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://ghfast.top/https://github.com/1broseidon/ketch/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "ab7a2ad5863bcc10d17978f295651297f84f2f9aad77afe93af1e7666ccdaa79"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9ea9f6a89718e8395e433caec0d5309993512877f4d18fefc8665085ba9af6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9ea9f6a89718e8395e433caec0d5309993512877f4d18fefc8665085ba9af6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9ea9f6a89718e8395e433caec0d5309993512877f4d18fefc8665085ba9af6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aef40397ba1e91f2f7be77acc4cfbcd46f20e7800cd364b34dd97c2edd0f8c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4ce9b0b85eb2875e592f4d99d979c94fed7c59a0600c01e6e2f9bb52d21ff523"
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
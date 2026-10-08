class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "325c9ab509f9b65a3d5bf5acb826afbfc50166bcd8bd1ab5f3c38cdb3c30930e"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0df2df55d93414c4373c1b1b94847ce16db22531a50e71a6307943341e18f50d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0df2df55d93414c4373c1b1b94847ce16db22531a50e71a6307943341e18f50d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0df2df55d93414c4373c1b1b94847ce16db22531a50e71a6307943341e18f50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4077db17750dd48ff59f8e4c31ee0e8f1f18da48b5bc7994b0d69c2d177dc133"
    sha256 cellar: :any,                 x86_64_linux:      "7de55d80fa1de139238eda8678087209b8528fea6c760ee0abf30c8a8a221f5b"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"atlantis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")

    port = free_port
    args = %W[
      --atlantis-url http://invalid/
      --port #{port}
      --gh-user INVALID
      --gh-token INVALID
      --gh-webhook-secret INVALID
      --repo-allowlist INVALID
      --log-level info
      --default-tf-distribution opentofu
      --default-tf-version #{Formula["opentofu"].version}
    ]
    pid = spawn(bin/"atlantis", "server", *args)
    sleep 5
    output = shell_output("curl -vk# 'http://localhost:#{port}/' 2>&1")
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
  ensure
    Process.kill("TERM", pid)
  end
end
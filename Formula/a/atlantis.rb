class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "ebb47be23b30141365e18870d1633a67f66988f774112ca7a62d818fcaf7f12b"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "274a7eb592499722c8bd87892d5db93b8e22fed8aacb1c7ea58a6c2431e49d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "274a7eb592499722c8bd87892d5db93b8e22fed8aacb1c7ea58a6c2431e49d45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "274a7eb592499722c8bd87892d5db93b8e22fed8aacb1c7ea58a6c2431e49d45"
    sha256 cellar: :any_skip_relocation, sonoma:        "9889130047744d5d806a3c082ec1bf37437c97c3b6e1949844d5341ee9cbfd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28783d6f1ab6552783d5145a57e51f3c6de8487e8562a63468f41c34ec8f8b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d395c5d9beb267f194ce2acb8305039f416ca216774caa0f11b2e1c55b16b94"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"atlantis", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
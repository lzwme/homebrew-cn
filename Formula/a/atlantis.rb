class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "688d8972dfdfda45e13fbea33257f4b2ba8da1be6cf0b21d9f06ba96b1f5aedf"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31ec45fab267dec686b311866c4d286fc09197f11ef6e7a49dc725a4e382f4a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31ec45fab267dec686b311866c4d286fc09197f11ef6e7a49dc725a4e382f4a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31ec45fab267dec686b311866c4d286fc09197f11ef6e7a49dc725a4e382f4a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5d41accd908abfe8d98a3ca073325466ce4a2612a2763177d8f60f11082bef0"
    sha256 cellar: :any,                 x86_64_linux:      "a31226f8446761f95c4ca0edb0d039ae19a6a3ca12d0b1390288c0141de9d195"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

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
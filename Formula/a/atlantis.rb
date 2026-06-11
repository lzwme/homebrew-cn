class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "ba871944e95a3b366f877d16e061e72e11ba02b898f131d22d3620aabee87fd0"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4cd86e0514bd799e07a9f837ce8dcc12e5a583d8ed8c21a49fe9066b19b11b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4cd86e0514bd799e07a9f837ce8dcc12e5a583d8ed8c21a49fe9066b19b11b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4cd86e0514bd799e07a9f837ce8dcc12e5a583d8ed8c21a49fe9066b19b11b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c0770962ac7f01c7e196b8525a26bad176d5c79b8957f582daa6d0751f3141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b6e952222ac5fb20be681b90d9fbdb16f3625e5e2f05fb1db926709a01b439"
    sha256 cellar: :any,                 x86_64_linux:  "1ac31f53928beb73f9e40b4d4afdcc6006a3d5168f1496c9d02e69d58e0e5599"
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
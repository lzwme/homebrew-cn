class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "e216b4da18baa9f5778a6fdeccad45e5df39370066005bf6f3532812986b3538"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "667b0f36e9f970b2c8513a5be35e118c2edc61a6b376f0971f72f6f9c437d959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "667b0f36e9f970b2c8513a5be35e118c2edc61a6b376f0971f72f6f9c437d959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "667b0f36e9f970b2c8513a5be35e118c2edc61a6b376f0971f72f6f9c437d959"
    sha256 cellar: :any_skip_relocation, sonoma:        "3af3c8ed20df2e7a25e919c073c1e28c54473455c3db0a94bbe4c943bd10670a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33570ae87fd5d55bdb909c672c371142024278d35c01e38fb1cad0c7c98e44c4"
    sha256 cellar: :any,                 x86_64_linux:  "5b31bb2302b3aa1ecef6f0b1e547d8d52e7e4ebfb4072964d4b779a0f114f628"
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
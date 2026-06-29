class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "739fa2a1c2658089d3fb824df51f09a91d041ba06ab1f8366f4ee819031f4657"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d84a0ecc1e59a25706e977469b6524aa14567bb507aa4e1772e69ca1e9fafc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d84a0ecc1e59a25706e977469b6524aa14567bb507aa4e1772e69ca1e9fafc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d84a0ecc1e59a25706e977469b6524aa14567bb507aa4e1772e69ca1e9fafc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "af9365729d8f2671b0051ffba93cfb69d92afdbc9cdaaf3219671d2eb390da88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d76693b06589a8dd898156f2a50fa51db5b8cd2874dc0d18088211211766c0c7"
    sha256 cellar: :any,                 x86_64_linux:  "399bbbb4cf7a114640ebb26848ed43848c3d8764106e52ee84a7e7ca3fb4a579"
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
class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://ghfast.top/https://github.com/runatlantis/atlantis/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "b6120ac5b3d92c6e8619877a95c1fb20e473f8f9d3a982fa6a840969dfe0f149"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe010b81a7d215a39c8da8965e36bd5646876ac8c0592a62903dd960493b0d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe010b81a7d215a39c8da8965e36bd5646876ac8c0592a62903dd960493b0d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe010b81a7d215a39c8da8965e36bd5646876ac8c0592a62903dd960493b0d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3b4cefbb276a35d9af41b48e985cbb545390177bff2a2e172d1c886aaa87e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a879d8a6c592336bffb18d3b4ec934364991304539d0cdc5625ff0c6e3f5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8999bf9b82bb9b60111d48c941cd41bc21997a0e8dda714671cfc846e2248c6"
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
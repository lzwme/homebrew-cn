class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.181.0.tar.gz"
  sha256 "2e66d18ac7464581962be46a29410e0a91aa7f1d12ebe0ede9f730d35d02d743"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be13170e7e117d3a69edfcc53a3a98f9cd44110de3fb7ca31ee7eeb95413f3b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "be13170e7e117d3a69edfcc53a3a98f9cd44110de3fb7ca31ee7eeb95413f3b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be13170e7e117d3a69edfcc53a3a98f9cd44110de3fb7ca31ee7eeb95413f3b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e48711d510850b8fe584114a7956e24d83b9d8202c416164f7c5b8c3b271c32e"
    sha256 cellar: :any,                 x86_64_linux:      "bc65ebb1ab1ad837684d826b5f3b6aab651b4e27011c2b1f4c7d10c0555bf723"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
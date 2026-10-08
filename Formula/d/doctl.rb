class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.179.0.tar.gz"
  sha256 "3b0a5ba2dbe6edbcd1cdd88fa6dc730ea5eb9768fe21320c08cc38d2ca89b05d"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab8ab55ed0a1cfeec0aec45f1b939a02789fbdf422bf661c84b0b1f80c93bc3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab8ab55ed0a1cfeec0aec45f1b939a02789fbdf422bf661c84b0b1f80c93bc3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab8ab55ed0a1cfeec0aec45f1b939a02789fbdf422bf661c84b0b1f80c93bc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d98394abf8a1dab4aa84c13667b567527e3f6f0fafd6f8de97d58f3b090f432"
    sha256 cellar: :any,                 x86_64_linux:      "a387f200bb429e67b0f558d5a804262e2486f38c6610a64f671891c6d9575039"
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
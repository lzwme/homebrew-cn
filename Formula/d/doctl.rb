class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.143.0.tar.gz"
  sha256 "4cdf2fc792f62faf60b07d29190bc9ec4a9c9ac6de2b279c6af6b626125606a4"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "378ffb1273d44c82882070bcbc7648d084d81aef10224550cd71bb3fbe6d0c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "378ffb1273d44c82882070bcbc7648d084d81aef10224550cd71bb3fbe6d0c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "378ffb1273d44c82882070bcbc7648d084d81aef10224550cd71bb3fbe6d0c35"
    sha256 cellar: :any_skip_relocation, sonoma:        "454b22e7c86c13f66de3a050a1e14e45a5a17c6ec08cbe209050eeb0258beb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa006b20008b19d83a80ee0fef0c349947891adfbe1fc1ab9acca3a41c3bbc19"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
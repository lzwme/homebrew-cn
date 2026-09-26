class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.175.0.tar.gz"
  sha256 "aa45675090255320d1b74541e1958bf677fb8525fce0706560a0e1ac53b3e092"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "daff6547080960a51e85fd2ddd545e73af05849fea3368a5b4ca9f33d9a1f049"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "daff6547080960a51e85fd2ddd545e73af05849fea3368a5b4ca9f33d9a1f049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daff6547080960a51e85fd2ddd545e73af05849fea3368a5b4ca9f33d9a1f049"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db70d1663ef2450b4c5a4b45c02b12cbb559a35164daa67a7e0c981ec6a05199"
    sha256 cellar: :any,                 x86_64_linux:      "6482fb918a5f88b032cceebf0cfc73ad01d135956c89de7a92248dd7f463f5da"
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
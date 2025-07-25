class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.135.0.tar.gz"
  sha256 "5effb6ef3ab5f4b6385833c87c8ffa5475ea2fe6094651c8356e72039f47a10c"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886f5a9595570abb1b31cb66c1dc4269988dca1db6212519cfa604bd0664cf27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "886f5a9595570abb1b31cb66c1dc4269988dca1db6212519cfa604bd0664cf27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "886f5a9595570abb1b31cb66c1dc4269988dca1db6212519cfa604bd0664cf27"
    sha256 cellar: :any_skip_relocation, sonoma:        "f23fc84cef85304012c42c183ae974c1ad243dabab44aa76bdac93d65443aa44"
    sha256 cellar: :any_skip_relocation, ventura:       "f23fc84cef85304012c42c183ae974c1ad243dabab44aa76bdac93d65443aa44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d7aff45a5563ecd7e27ad87ee77f5110b809c984a44261e75fe18d7346cf48"
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
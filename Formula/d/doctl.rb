class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.174.0.tar.gz"
  sha256 "badfab543d76edaa6266b94435ae40e94751a91f667f8c9602ebe1389e781192"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cef685e5483f5cecaaa7062e478038a012dd3b6e0a271aae596ee31d9ab0881e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cef685e5483f5cecaaa7062e478038a012dd3b6e0a271aae596ee31d9ab0881e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cef685e5483f5cecaaa7062e478038a012dd3b6e0a271aae596ee31d9ab0881e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d645686951ca2b56deeabd5b3c273c7f19aaff79a4227e582e9e0b7db86091b"
    sha256 cellar: :any,                 x86_64_linux:      "b34a49c108e4e7fba74159975f48d861a0047562734ba2c87ccb0d65a7340f53"
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
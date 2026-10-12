class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.182.0.tar.gz"
  sha256 "6a290c5760d0f706fec1e87eca278e230f3f41b7e2d3a1f820e355f2b4a99b66"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c333ddc4c1e4cf528c8e1257740afd4285972dd12eddddfd7851e7f9d839f6da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c333ddc4c1e4cf528c8e1257740afd4285972dd12eddddfd7851e7f9d839f6da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c333ddc4c1e4cf528c8e1257740afd4285972dd12eddddfd7851e7f9d839f6da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8db91be294ca458ecbf5095dd0cf8ebfd171f282e21af9fc0c93e6a33c407fe1"
    sha256 cellar: :any,                 x86_64_linux:      "6bea578c93731443790ed0565cda95e52368e202f4dd7d1759cfdf4688fa864d"
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
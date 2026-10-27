class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "eccfd758ca7d15048922795197a7d6bf933e0595e0077daf6c81fd6136a20d01"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50c00892fc5afba2db017a0c7430ba8423a55c082b24daa191e9594ff416b6ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50c00892fc5afba2db017a0c7430ba8423a55c082b24daa191e9594ff416b6ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50c00892fc5afba2db017a0c7430ba8423a55c082b24daa191e9594ff416b6ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ec2704f8940e1e2cb766f18d7393422870b458b88c7af83cca6199838bdd141"
    sha256 cellar: :any,                 x86_64_linux:      "4600f8d9b58f0702fc5b63b658e2844f183287ab05a786a4a820d4c5b4b83667"
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
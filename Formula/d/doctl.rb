class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.171.2.tar.gz"
  sha256 "2f0e51133d6dcc6bb0379dc060cda51351259aba44271a1853bfcaaa6ffeddd8"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b010a2ef87acf4e07b524ab32eab69b811f3a078b0b7167bb60ccd0f1e185cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b010a2ef87acf4e07b524ab32eab69b811f3a078b0b7167bb60ccd0f1e185cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b010a2ef87acf4e07b524ab32eab69b811f3a078b0b7167bb60ccd0f1e185cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "755da74b9c52afef9110261c6e148df5acbf836893fc8ba58f6849426509d32f"
    sha256 cellar: :any,                 x86_64_linux:      "c77afefcb6408de290d96955138f03f8357e5d907b9c7761406e807d8d676d96"
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
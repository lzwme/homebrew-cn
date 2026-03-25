class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.153.0.tar.gz"
  sha256 "096b9ecb024bf471ef9292eda2e04db211bf2102f4d150fa0ccb8a168d2b7def"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b988413fae44c260960c2bccfecd2661acfc60d737faf4bb46129009bce5d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b988413fae44c260960c2bccfecd2661acfc60d737faf4bb46129009bce5d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2b988413fae44c260960c2bccfecd2661acfc60d737faf4bb46129009bce5d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9339590a81667327344a13efff820a979bebdd243b414cc333c68c93c5117ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bee1f56cb410a432a05ac2873e2c0b96c087806cb9d35b59743976a818c2b823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dcf9ee3ed991fe7226c0af48b8690814ea5d0a05624294cb15190d0a4e08aff"
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

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.165.0.tar.gz"
  sha256 "191cd92b9ccf6c4ac0a4f7832209db447327d0e390f493cffcf2c50044cc415d"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e2a39dd6ead2598287a824d847dbb9bc16e84cc802adde6e95c3b110be5eb53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e2a39dd6ead2598287a824d847dbb9bc16e84cc802adde6e95c3b110be5eb53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2a39dd6ead2598287a824d847dbb9bc16e84cc802adde6e95c3b110be5eb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1283a607beb53faa771ea81ba6acc27402c0e16fd6f5c11b14cd3d31d54fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b4308f880c42645d599557ac3c9db229363521c047cd0fd56a3fee8eb393eb"
    sha256 cellar: :any,                 x86_64_linux:  "1a44ac638835527adacf665524fdf75cecbb290faba2cafaab3ccd14a130eaa2"
  end

  depends_on "go" => :build

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
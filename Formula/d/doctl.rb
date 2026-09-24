class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.173.0.tar.gz"
  sha256 "6ddf78e2feaa9b3f4d157e71ddc29c3f2f2f643b8dd97fd38649127aa2aa2620"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9446adf0dc083d8156cfaa8b9c7cc2aa660473102c7bfaa96596b23a2c47b317"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9446adf0dc083d8156cfaa8b9c7cc2aa660473102c7bfaa96596b23a2c47b317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9446adf0dc083d8156cfaa8b9c7cc2aa660473102c7bfaa96596b23a2c47b317"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc2b8a05fdd71e702d39380ae55d06cf1aaa043f21b99b6dad66ee756f990476"
    sha256 cellar: :any,                 x86_64_linux:      "4dfbbee21428dff1da1feaac3d18ed554d1a46ffcc637d9d4db0c47ab9919053"
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
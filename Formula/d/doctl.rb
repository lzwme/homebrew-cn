class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.178.0.tar.gz"
  sha256 "7477748c75c00b2ace6f9349bf40a7b63dcde122227ce60c019a4769d59a13af"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7a57e71a735ec7b076f9b06a72ff3e7ee7087379f709aaabf28fd8ea7e7b8df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7a57e71a735ec7b076f9b06a72ff3e7ee7087379f709aaabf28fd8ea7e7b8df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7a57e71a735ec7b076f9b06a72ff3e7ee7087379f709aaabf28fd8ea7e7b8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38860e78aa2e5041d384e51384db3018e7d538424f5e8f0aa795626548b09419"
    sha256 cellar: :any,                 x86_64_linux:      "76c1d0b682a55a62e952386b65dbd16364b6f453d877144a4937b0813bb8bc8f"
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
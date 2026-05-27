class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.160.0.tar.gz"
  sha256 "dd5be822f0ec4a55d418f14acbccd2a4e127c514dfade78224fbd003309b57c9"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38d3e601bf8d9f242e9eb88c874a929670cbfbd46e0fd8af2038de9bf547aaf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d3e601bf8d9f242e9eb88c874a929670cbfbd46e0fd8af2038de9bf547aaf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d3e601bf8d9f242e9eb88c874a929670cbfbd46e0fd8af2038de9bf547aaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc29f57dfdd32765709437dee2c7b6be8af0bdff174e010004606a67a2d3a8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34d6ca17e2140adda78b734056f99cfa8f3549a60fe19fe660cd45f909698247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00cebbf09e6c44ea0f70041927639ac5e3dd48f8c9fb8af1921f0a141855ff84"
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
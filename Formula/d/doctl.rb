class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.149.0.tar.gz"
  sha256 "5326721185e6fed5853bf1334a5c8b2fca627a0aa6d531bea66903f849586aec"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "065d5e754adab3dd0d583199272ad3cf9f512998852669344476fdc27d10be7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "065d5e754adab3dd0d583199272ad3cf9f512998852669344476fdc27d10be7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065d5e754adab3dd0d583199272ad3cf9f512998852669344476fdc27d10be7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb679cbdd58429cde737e6104be12f29d25feb46ef18da6fc4505d015e55ef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b339fd5dc3abf40a48999df9732866e8c1d1803d87592e14673dfb73e5955053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df20ab13c80ca8e232a1994ddb2b268acf52841652a46bc2cb6ac7b14a563fc"
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
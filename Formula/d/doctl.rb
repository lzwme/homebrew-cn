class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.134.0.tar.gz"
  sha256 "7c9602463d9937dd1ca8890fa1dd9ac236b4618796c1bdcf53bcd3e38cfb3226"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d0383c03db8c03bbe4f7290ffa0addf2c824997ccd06d34ce6ab9af06b891d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d0383c03db8c03bbe4f7290ffa0addf2c824997ccd06d34ce6ab9af06b891d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39d0383c03db8c03bbe4f7290ffa0addf2c824997ccd06d34ce6ab9af06b891d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aee5508cb520c8be5f0cc33213c97d1bcab5dc0b03482db627cc11c02634ef24"
    sha256 cellar: :any_skip_relocation, ventura:       "aee5508cb520c8be5f0cc33213c97d1bcab5dc0b03482db627cc11c02634ef24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beeea59df4ba7850ba28dc61cacc3f93ebc6a245c399ae9bf4ff328a75f07a2f"
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

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
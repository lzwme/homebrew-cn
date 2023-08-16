class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghproxy.com/https://github.com/digitalocean/doctl/archive/v1.97.1.tar.gz"
  sha256 "a6bf64cad7ffb111e40b3fdfbbc93694d00a0b441a4f89b35a382c0a1b8f3d05"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96fce2701d33814b763d37c1e03eba82aa737b3db48880bb4a04685b3c4f23fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96fce2701d33814b763d37c1e03eba82aa737b3db48880bb4a04685b3c4f23fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96fce2701d33814b763d37c1e03eba82aa737b3db48880bb4a04685b3c4f23fb"
    sha256 cellar: :any_skip_relocation, ventura:        "6d10044032b3ae74d87141cb4b1cbcc0dfccea01ee57107b9476f5403a36af93"
    sha256 cellar: :any_skip_relocation, monterey:       "6d10044032b3ae74d87141cb4b1cbcc0dfccea01ee57107b9476f5403a36af93"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d10044032b3ae74d87141cb4b1cbcc0dfccea01ee57107b9476f5403a36af93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e9e8826e776bc485d683edc39762f5bb268f33bf7b7c5a7642d072590f555ca"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
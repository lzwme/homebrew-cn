class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghproxy.com/https://github.com/digitalocean/doctl/archive/v1.93.0.tar.gz"
  sha256 "cc940089c2c3fa48d2f6a78eb032bd9e778fed5b0c3d91e4bafea6f03c03ea5a"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca8c2a2ecc92404975c8e68ea13931efe4650d8dffb27bbf378788bdb70d5839"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca8c2a2ecc92404975c8e68ea13931efe4650d8dffb27bbf378788bdb70d5839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca8c2a2ecc92404975c8e68ea13931efe4650d8dffb27bbf378788bdb70d5839"
    sha256 cellar: :any_skip_relocation, ventura:        "ddc94fc48424d72fbd4c590416ce1b4a754e1e3e2c02c150917fafae2d2710a2"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc94fc48424d72fbd4c590416ce1b4a754e1e3e2c02c150917fafae2d2710a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddc94fc48424d72fbd4c590416ce1b4a754e1e3e2c02c150917fafae2d2710a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a491431dd665736465ec705905473863c24f6e2284e1bfdfa77420220fc3fc59"
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
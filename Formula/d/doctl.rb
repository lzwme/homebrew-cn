class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.138.0.tar.gz"
  sha256 "2c04f5b1e016e3f7c0b101d936f67a73ec8b41b0179ff3596470065859ee76ef"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c20600bb5b4ec17b3fa43055b8759b4bc17b7da76160ea883dfcf4e8224977b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c20600bb5b4ec17b3fa43055b8759b4bc17b7da76160ea883dfcf4e8224977b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c20600bb5b4ec17b3fa43055b8759b4bc17b7da76160ea883dfcf4e8224977b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fba11e846807fecc43076140c8c898ea0beb0423a1f002125118d9255ca436a"
    sha256 cellar: :any_skip_relocation, ventura:       "8fba11e846807fecc43076140c8c898ea0beb0423a1f002125118d9255ca436a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9ef800522770cd45030a4086e88bdfb807dec7fb277a2e9764c630731f121be"
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
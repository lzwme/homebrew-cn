class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.140.0.tar.gz"
  sha256 "10c357279a3a9b47c1d96d246f8d0d93cfbca0727dc15bf240eeb82ef92c7749"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3fffcad4eea7cdb01804a5286b6d9d767d292c7acfb36bc2de3ff2c7b5ad8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3fffcad4eea7cdb01804a5286b6d9d767d292c7acfb36bc2de3ff2c7b5ad8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc3fffcad4eea7cdb01804a5286b6d9d767d292c7acfb36bc2de3ff2c7b5ad8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "988cb2676b377bab47ce51a84f857b5b3b7c735723999989d4d1abafbddd32b8"
    sha256 cellar: :any_skip_relocation, ventura:       "988cb2676b377bab47ce51a84f857b5b3b7c735723999989d4d1abafbddd32b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95d24bd5349fc1e6f17318354dc35225a145e5f11335218f794d2245029632ee"
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
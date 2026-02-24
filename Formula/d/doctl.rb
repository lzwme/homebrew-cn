class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.151.0.tar.gz"
  sha256 "1319740897b7bd6d1bb5741668389d18b2aa06437cdf70f1a4fde40da356e81b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d01ab322f4a061552a7b40ac82bb3eaea2ef2c97fef19c344665a87a19c751b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d01ab322f4a061552a7b40ac82bb3eaea2ef2c97fef19c344665a87a19c751b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d01ab322f4a061552a7b40ac82bb3eaea2ef2c97fef19c344665a87a19c751b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38e75c2b33a81c3cf009500e86c136f01969102a4a872cf169c4393348abf3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2358753e69ee805ca580872227d05ac455ea4d9dc83ea68667c49be9ef3dd4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd3bad21083cb5c9ffebe1393b1608d7440a9f3fb9da3310c9b4aae4ceeb08c"
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
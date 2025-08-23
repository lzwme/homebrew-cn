class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.141.0.tar.gz"
  sha256 "148ad29a07d1974838b49b76e32a14c84688f726eda96933e758c9a9eecc55f4"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f124dd5a460f3fc004a00f771713ab56ee60e9df98856b9c1499d65753f0ab60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f124dd5a460f3fc004a00f771713ab56ee60e9df98856b9c1499d65753f0ab60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f124dd5a460f3fc004a00f771713ab56ee60e9df98856b9c1499d65753f0ab60"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8fbcef107e57a192da0ca1934f3647ff3442fd62971be61abaf9aff0335de92"
    sha256 cellar: :any_skip_relocation, ventura:       "d8fbcef107e57a192da0ca1934f3647ff3442fd62971be61abaf9aff0335de92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c78997fd1b807294b10371d350791b0e35e3eb08716bb335168d87b271f78e32"
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
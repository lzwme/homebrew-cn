class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.162.0.tar.gz"
  sha256 "2061a1a10f0717030997d3c083642ddb951d64d86b9476b88f0948bc4cfc4605"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec899131a73acdd3eaf0836c66b405ab9e1ea40893109bb12eff7467c754ddab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec899131a73acdd3eaf0836c66b405ab9e1ea40893109bb12eff7467c754ddab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec899131a73acdd3eaf0836c66b405ab9e1ea40893109bb12eff7467c754ddab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9ad3ed65de182795c0c980050e76ba8a922e8360d9580d7606de994e011a167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d87b90384e868ac1dfbafdac7fde2a3f820cf604af9d690af57c726ef318dca5"
    sha256 cellar: :any,                 x86_64_linux:  "29e8c6bcad7604defd98ae104d13a34655e5d67103fc04a50851ff07445923e8"
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
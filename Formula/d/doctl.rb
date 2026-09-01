class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.168.0.tar.gz"
  sha256 "a5c7c045d7f14a8f4e7249e07a5302520f5b3130137360047dd7964246527905"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c2c9224345118f44bb063423a735ced2a120f95ce1993ffe2aacec0340c2138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c2c9224345118f44bb063423a735ced2a120f95ce1993ffe2aacec0340c2138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c2c9224345118f44bb063423a735ced2a120f95ce1993ffe2aacec0340c2138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e1ad06f4d61d195a438a304fcefbcee034dc890c8f3aad3fcdc261863df3d2"
    sha256 cellar: :any,                 x86_64_linux:  "82e535f0f76c7e3f18ce41962d7957439bb9f59922f3f6e07fdbe81c208e6fa1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
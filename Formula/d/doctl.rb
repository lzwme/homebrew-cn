class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.177.0.tar.gz"
  sha256 "66e8d6b7efe3c27c180402c723a3b68f62f288ea3ab58ca01d65db33747770dd"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f1c83e9e4f7dc5252af5b8db57fef4f8463b6a7440e05eda6ba91fc7a79df77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f1c83e9e4f7dc5252af5b8db57fef4f8463b6a7440e05eda6ba91fc7a79df77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f1c83e9e4f7dc5252af5b8db57fef4f8463b6a7440e05eda6ba91fc7a79df77"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "36f3063fe282470ff564c7b0f20d8ef1a8748f96125a9ae3ca4d854250cae868"
    sha256 cellar: :any,                 x86_64_linux:      "2523c3b952bc2744f63c50ca5b5ecfc6126d2581c834bfb4fece075a3aca84ba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
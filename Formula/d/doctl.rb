class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.166.0.tar.gz"
  sha256 "6a8c7ea59105f6274be9efeda947c275cd64b0e1f9f3112c9b2d6385d7994007"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f516d2eb828dbeba6799e00ffafb3951d128f212d3d6d61307f9b0474d524167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f516d2eb828dbeba6799e00ffafb3951d128f212d3d6d61307f9b0474d524167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f516d2eb828dbeba6799e00ffafb3951d128f212d3d6d61307f9b0474d524167"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d7922da21cfbe7fc04f10abcb33ff13d3c804cf66b19e61bc4a5784c2ecf083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aac3836d3b2d6ad4be0fb671e3642bf979488896db4618fa2155916b29ad869"
    sha256 cellar: :any,                 x86_64_linux:  "bfea3d4b6e1b0178f341b4e76399846562af7d7dc38a28d78d7971102f02af98"
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
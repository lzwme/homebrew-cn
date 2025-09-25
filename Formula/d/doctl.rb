class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.144.0.tar.gz"
  sha256 "186db1a392bda28ad0111106c7234df69e6fe4d093fcacf62f291c1af2591d28"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f672f3903f3072ee5325078899e04c7ad8444bfefff2eec3732b5e85bfa6abe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f672f3903f3072ee5325078899e04c7ad8444bfefff2eec3732b5e85bfa6abe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f672f3903f3072ee5325078899e04c7ad8444bfefff2eec3732b5e85bfa6abe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c5a7b5d639e1dc70b936c9d6fa04df42bf1153dcfbb3ef526ce8fd8e7129cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc029936bc1906d361ca75c94ae256006fc44d073dd5a99d49dbaf494b074c8c"
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
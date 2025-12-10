class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.148.0.tar.gz"
  sha256 "be347ed111b3e0a2987cb492e2bf1fb7ce8d06e215b6130797fd235934d21779"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b43cd5a1f6f77f94e82de42382b19097e3e3dcb5ae976c8c65b113a75a8cfe87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43cd5a1f6f77f94e82de42382b19097e3e3dcb5ae976c8c65b113a75a8cfe87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b43cd5a1f6f77f94e82de42382b19097e3e3dcb5ae976c8c65b113a75a8cfe87"
    sha256 cellar: :any_skip_relocation, sonoma:        "2487f5742634ad6b42705c6cc952adc3bf27c98341e4e99bfd194532fee7fe70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8887f76a7d9e993809b83d8c8ba91ac3ee7baedd8968d52c914023f19569b279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2226222d8c5078a64cf35383d693c24081b8bc1ba0c1d107f98996bf29586cf7"
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
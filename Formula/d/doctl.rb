class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.139.0.tar.gz"
  sha256 "d91611d46fe40cd3bc756749090a64a11325d645ee601575373fda48a69525c7"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e6d993d7eb4b004c4ae4fc1f0b23fcfede0e931c45b5e42ea3e38092ba71ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4e6d993d7eb4b004c4ae4fc1f0b23fcfede0e931c45b5e42ea3e38092ba71ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4e6d993d7eb4b004c4ae4fc1f0b23fcfede0e931c45b5e42ea3e38092ba71ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "58dc15f5aa095af9a58c7d45db0432ff36534e95208370daa7baa73c26bbb98b"
    sha256 cellar: :any_skip_relocation, ventura:       "58dc15f5aa095af9a58c7d45db0432ff36534e95208370daa7baa73c26bbb98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "032fd8885f13021abd57d6f178190a180608fc7c7eac2aaab571a8027688a321"
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
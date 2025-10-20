class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.146.0.tar.gz"
  sha256 "37aa7baf777ac9ad5a8a5d1f82f120733be6ad270a5e2ed692c0853c2e48cfba"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4374c3c9cb92d4606d964b3ba7c4d43d659389061e26d02ccd4d895c84314a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4374c3c9cb92d4606d964b3ba7c4d43d659389061e26d02ccd4d895c84314a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4374c3c9cb92d4606d964b3ba7c4d43d659389061e26d02ccd4d895c84314a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "29a3d48b3b8c3d382afe321b2e3a0553f79425135f535c92310a5d5cac78c0e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42eac77ed8a2d90afa8619c7edd99aef9c0a0dcbb0802ee9f26960fec48342eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ff38c79c63171f4e7ba8e550d5dd2e1539899a8831838053aa82aee6f22e7b"
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
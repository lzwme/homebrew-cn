class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.185.0.tar.gz"
  sha256 "99178aa2852c461c87058909fa07be260542f76dad734fdcbae9442ae3420f68"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d58e4e37c4281ee5a1523a7df1db5c61c4fb7d9ce79c490e36bd1cfaafad14dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d58e4e37c4281ee5a1523a7df1db5c61c4fb7d9ce79c490e36bd1cfaafad14dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d58e4e37c4281ee5a1523a7df1db5c61c4fb7d9ce79c490e36bd1cfaafad14dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff0607aca721f17ea66288801b8258cd9656166f473dfa90c027e0407ef23ef6"
    sha256 cellar: :any,                 x86_64_linux:      "e9c981e933fb141523a074f1ada786ead4d1ab730834ddef34b500a9e98d54e7"
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
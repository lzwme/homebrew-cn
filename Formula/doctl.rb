class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghproxy.com/https://github.com/digitalocean/doctl/archive/v1.96.0.tar.gz"
  sha256 "5963bfb113632df33d0ef6c2d076cedd180f73ce82f3162e7d1bc93b190a9951"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8857b4995ccd62ef8a0ae65a0433d5463d5a4771fdbe5a88768d09cf47a7f50a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8857b4995ccd62ef8a0ae65a0433d5463d5a4771fdbe5a88768d09cf47a7f50a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8857b4995ccd62ef8a0ae65a0433d5463d5a4771fdbe5a88768d09cf47a7f50a"
    sha256 cellar: :any_skip_relocation, ventura:        "dbdfd0d1a0e02ed4a56f9d8f390e9ad13532e0ea48c811322904846c883bd108"
    sha256 cellar: :any_skip_relocation, monterey:       "dbdfd0d1a0e02ed4a56f9d8f390e9ad13532e0ea48c811322904846c883bd108"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbdfd0d1a0e02ed4a56f9d8f390e9ad13532e0ea48c811322904846c883bd108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20105663239a2af7aa192f37a9b2bff543aebf25155d7ec0911ea8891f4d4d9"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
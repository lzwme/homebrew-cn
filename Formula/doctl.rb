class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghproxy.com/https://github.com/digitalocean/doctl/archive/v1.97.0.tar.gz"
  sha256 "98ca6b4ae7ce77ef1eff2701a158c840e783deb02bfe0870de1c4a24e14ff2a9"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb894c67e3a7a3ef784ccf7a46c5ce21e1130c45c16a7ba603b80ab30506e919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb894c67e3a7a3ef784ccf7a46c5ce21e1130c45c16a7ba603b80ab30506e919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb894c67e3a7a3ef784ccf7a46c5ce21e1130c45c16a7ba603b80ab30506e919"
    sha256 cellar: :any_skip_relocation, ventura:        "3c0bcbf20db82ddc0c98b753117b9f0b1e295949517e3492cc09a4f0e0351a64"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0bcbf20db82ddc0c98b753117b9f0b1e295949517e3492cc09a4f0e0351a64"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c0bcbf20db82ddc0c98b753117b9f0b1e295949517e3492cc09a4f0e0351a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9eeca76d93cb5f36bb84e99f8c05cdaeb99311033fc37b1fedd20a8c24c4b71"
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
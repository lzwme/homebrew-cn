class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.183.0.tar.gz"
  sha256 "e5a0940e43bfe13e55af601b73dc895b303aa71c2bfab705c2094dd417c1464d"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa02d34a4e58a1233e316683ae2a3fa70ceda8b3a0b25ba419d45bc1d40c642f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa02d34a4e58a1233e316683ae2a3fa70ceda8b3a0b25ba419d45bc1d40c642f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa02d34a4e58a1233e316683ae2a3fa70ceda8b3a0b25ba419d45bc1d40c642f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6b36be9b1aae01f33d93edc4e8bb99646eb43cab3cfde269419ea29e200563d"
    sha256 cellar: :any,                 x86_64_linux:      "f8ef18d125e0ecd8de58edbc061ff03d2357fa640f0362d3c030e3da5b7afeeb"
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
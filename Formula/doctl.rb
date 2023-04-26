class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghproxy.com/https://github.com/digitalocean/doctl/archive/v1.94.0.tar.gz"
  sha256 "b95959b4dd22cb8822de4b28fa92c2f42d7598795a27ac19f801463e49a7329d"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11e517bf9b2eabc5b3283fe34a78c13aeb865944994fb98bce07d52d3659205"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11e517bf9b2eabc5b3283fe34a78c13aeb865944994fb98bce07d52d3659205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a11e517bf9b2eabc5b3283fe34a78c13aeb865944994fb98bce07d52d3659205"
    sha256 cellar: :any_skip_relocation, ventura:        "089c0ce7df07d52a5cf1b1e1d12232a91b456786efb172821d53d49a597d4b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "089c0ce7df07d52a5cf1b1e1d12232a91b456786efb172821d53d49a597d4b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "089c0ce7df07d52a5cf1b1e1d12232a91b456786efb172821d53d49a597d4b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfd02cfa7f6884d79eef5d62177c769aff9ab0dae98eff266d43d251193d982"
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
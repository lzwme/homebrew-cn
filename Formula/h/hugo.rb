class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.167.0.tar.gz"
  sha256 "10a31991b4bbfbc458282e9ad3752b186ee5d118b3ca82dcf067d5a8cbf9363e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ffb5bbed101fec8f572ed542ea515b44d1320af2cc8e115cdb84ee7606992adc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9776a68646b53834548c0aae67e51f3b086328de0eb70b0cc0b25afdfdbd4d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c7726784eb1766812471e67672d61cf2a778ad3d7702301fd69ee6cc4740eaf"
    sha256 cellar: :any,                 arm64_linux:       "af4a81b709c0bfa829b5d25c7640847761e68bd841eb98993a5efa48bd3bf9e6"
    sha256 cellar: :any,                 x86_64_linux:      "87d03fa89671c6026efbad74cfb14853ef3390b0176ea25df9a5d85117b6e941"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.159.1.tar.gz"
  sha256 "4a32bf9e896fb6575aec409d5e2d3988841f593cd91d77276abeb3b5a125794c"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dabf6d3e43ef456aebb743203dd96bab5ac535c19ea02add58b7911b2a43d25c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac308d61e49f320af7b480df0d49ca39178e96739bb3e688294dbfde0df9418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea41df43b3f9ec728a3b451a6aaaaa313236ae03021cbd55872bbe1455c98004"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a6bdd2c56359f6fd40051dd31d9e7aecab58d00ba8a201cbbd4c08e6626d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f715ede2ecb1b4e7d79bfb7188116f2104903bd06af278922a92a250c36adcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e34069d3a25eae2a6d8c7d6ac3392073c63671bbb4d0ef765a7c1f77b36e41"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
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
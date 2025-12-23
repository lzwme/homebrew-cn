class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.2.tar.gz"
  sha256 "e0afb51d479cd4edcc4c775b858d36ffbba1f66ae6e288e0fd0fe2b4eb3d0f10"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "798c0b5ba47fa62da06cf3ac98a1c4631f86414311b79f4b0afb08aba6e76432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d782102c487167c97b096fe271f554d1d0b6c81f54e84ff00988ddfbc44f5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a9e5b986fb001e0c01e91882add817f0ff2edeec89c84b42880e71fa417604"
    sha256 cellar: :any_skip_relocation, sonoma:        "c031fcfb648439b34d20565bfcc704a8eb30e0a2792f49c6818d685ef880699e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "334970792a7f5b5ab6011ea55264706b5f7ba45e94cd65e510cfdd2781a1fe66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace5c8c2111cc855b4281359ed2235937ae67187a19f40e2d2f2bc314c3925a8"
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

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
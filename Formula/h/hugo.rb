class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.157.0.tar.gz"
  sha256 "c471db355c547ff8982102704783f49514fd572831f15396646e468556e1e43a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f16c306789517313f191e7b7dbb4ff1f8d1742754aecb02bf5a0a13b16e3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64cf6df269b7e839957e51b0a24ed1536e850f4cf828136c5d607313fd9c7881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdd2d6a05ab67527b957e91a5e2a97d2fd5066377ec0f0af97f7c6260831f009"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef63c4fcd59b9677f8f122984e31dea0207bc256f4d356ca0d973a430cec9e24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7920bd59e58a82c3ced30f2861e3cf1bbd7cf2f5f5f79aed25dce3c982c4c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d63d7f3cf05be7b1ac16cd7362e5385978dfa9e81cb1d9f77cc93a218f09135d"
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
class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.149.1.tar.gz"
  sha256 "4ea9e45160004b3824a7aa82d594120966c596c161cc27621000b0e0af7f11ae"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9ebe8cd43ad11ff20c8645af81dd5c81530041fb5779d69fe29bbe9c4f06b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba2a1eceffab3c16fe12fdb2e6a99160a02fe29845a3ba0a4da9457ac4b0f5d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "818ea7fac92e24627c66bf1af2ca93a2025ad59f6e1f45d5a0eb160e2f61741b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2c92ee60b832fcfe58cfa90e7a5ce2bda127c23e384091ed3c6d96f65874234"
    sha256 cellar: :any_skip_relocation, ventura:       "f108c3c17cb1f5bf6ddc974781bf08436db0a7f77f2a04278316dad9af9b4d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0515b27b3e9550bce6e1afaf6dc92f6f99252e1c2371448e988c02e204ade48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6167f855af63c7010bdf55961621fbbcd2c8eb57cc42c3a378a71af8e9a213"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
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
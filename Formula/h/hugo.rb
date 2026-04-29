class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.161.0.tar.gz"
  sha256 "96c2470685888398c650a5b90da1c2d55c4425fc0e436d93be0fa3b4e05c52dc"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfd0cef5c2277b9a0b9c00934b55d5829c05b7adee31b0189cb543efb3cc007b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f46670f8ebf21e296545def30172a50c73117a4e52efc6a3a9435f05cf22db60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465dc12f46befbe9d2753d3dee0ccb31c0d183d9d8b80ace829fb01e39ca40a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "00666d805243cf546999e1a65d108c1d2b8417f264f507f4db910e0710e74216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c072b1a42308ec46a843d1aff3602f68a331288b08181b002fbbe591c01573cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af548865f081f55aae8df9af164fa467c458260653534054b0a8b5a35faa3b5"
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
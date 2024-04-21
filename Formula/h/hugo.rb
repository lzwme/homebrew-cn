class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.125.2",
      revision: "4e483f5d4abae136c4312d397a55e9e1d39148df"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3507e69ff6fcccbbcf82ffc4343f7a82c43b6486c2040dee0cdf5756b7a1de84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b409def4ce19c21f8f9bb71129df4a053582dbb53c02667782794badf516af74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61547b426f60936f39d69be4ecbb1128c81c0a438deecb1eecb03bdc7da72fcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "622e31fecce76a5b8e9b95531d39f7460363afcb733097c3a4732b8881d737ab"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4a052d40ad6d3cfdff944edd0101d1f4dc474568be41ca7ce6e61eddffd85f"
    sha256 cellar: :any_skip_relocation, monterey:       "00c890a1bcb2d8f31d4fd8e0f88e47699eaaf1e7b730ab8a3a0bcf5354697bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ae9fd90c5fa5f83e2f231046cbeddd395a7b5415434bce568b0dc2dca66303"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{Utils.git_head}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_predicate site"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end
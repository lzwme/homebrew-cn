class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.121.0",
      revision: "e321c3502aa8e80a7a7c951359339a985f082757"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "749ed001ce5723a70c8ee6e20be37c56f5f341310be727adb87ef84e1a53618a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "933a5afa273fe83e228e95651e68d9e29addd4351812137c613cfe083e42fb70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28f4a8573de79a1dd6d5162498f8673f310994bc8873026edb06898664dcad97"
    sha256 cellar: :any_skip_relocation, sonoma:         "fef5093e4ad0e210e9f6a9644f5f84d0b239b83e9a75c61a282afb86bb5572a6"
    sha256 cellar: :any_skip_relocation, ventura:        "1ddbbb238126b587e141ac06d7fb33db34dea1d7928990736926f8d5e494ff7c"
    sha256 cellar: :any_skip_relocation, monterey:       "2119fc54a625770c3ab449cd88e597a1f53ca0908ffb6331b33f16453626026f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68e95377d30d13f6a9da86bdfcc6544020530fa179887eb56437d6c17606d18e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
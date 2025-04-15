class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.146.4.tar.gz"
  sha256 "0f22fdc8116c0e30f4ea2ba6e2ede2e7d00682cc64f2419dfcb1cfd77966cc88"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ef7fbdf59f1cac7bedfcb224f6ab4c06c94e9c1335ee61f37cb85713be6058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b590a899c425361a919138949a60ec8592b5975bdf5d7747a006dcea57153de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "617b99d70058f9633486798fb2965869a593e4c932f0e3d0057e87cdc6a1513c"
    sha256 cellar: :any_skip_relocation, sonoma:        "765838f9bc32f962634e9fa1f0d41c421675e5e0e739d90af857ca6442b3f3c6"
    sha256 cellar: :any_skip_relocation, ventura:       "4da126e7e3d0ad7669af44503fa7ab0c5b42d25404e6964cfde01a09bb178656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a07246b76d84991a542ca51763a6618902f162fbc86c5cce7dc7d2543ab0488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce813ed4d84c71ae27ae915a3894bc1dd89410b53df8c7e91880276b3293f240"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_path_exists site"hugo.toml"

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end
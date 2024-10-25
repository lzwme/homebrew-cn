class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.136.5.tar.gz"
  sha256 "d08858d21faec46075b8988d1ed3b16239daea426574cd3b07efc1e23db927f5"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57172fa29c47e87633968a01089a3e51b8ee00317ac567720d530526b39d2731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aec3e60ddb34603685956abc3986704091f5c15f7a3f98ae43669fefb20b6ce8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "772baaa686362d55cc44607a1a67549c7c39bb215c5c97fabf98d405db6735d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e5d7af24848f3bbcd0c0f6f1cd430138552b645beeb835d2a29be459a01134"
    sha256 cellar: :any_skip_relocation, ventura:       "e6c83f3330798cce13a1ed120da135169ab114b8a1d72a82d6f21fb6df6ab423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bb77a650a1ffc692cbc78dd31b214d9bb7c408d97d7b2f495598245825e6a2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
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
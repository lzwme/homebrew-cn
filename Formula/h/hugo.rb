class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.140.1.tar.gz"
  sha256 "22e2ab8c0bd0b8adbb215f0dc225d4622ad6330f3df17bccb7eba9c00a0d3f5d"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2bb9c752e3fcba4c138167901e28a620c6a55c6cc16bbf73f3cd8303f9f531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd3aaceeb5b5fcd20098dd3eed41e036e5b51d63106e43a0f28ff4cbb41ed74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ad17b2749c3ba49ab3e79ab556986126a25130f2db7c2f5000831680280bdec"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff790ac9388374325950b71d766b0470555b96b6dd5b18a68e0d8e5dfbc3980"
    sha256 cellar: :any_skip_relocation, ventura:       "d1b1a70cd06fc9a98bf02e7089287368ae1f3168c0ade3478bbaaf2bad31ca88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83465e569f0709223109bdbe054b6e713887aeb59e40ab14b62f5ccce13b8cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

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
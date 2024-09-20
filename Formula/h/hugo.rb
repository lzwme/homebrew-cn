class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.134.3.tar.gz"
  sha256 "9975498a69df214dce634802d14c6a8746966692084c9e99ef1c799b9b55b66b"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ca8337a8b1ce152b26ea01b497b184b20ddc6acbaad792d3ce5a06504b8431a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeb3679053306b36a1ac0fd66d4e9d4a37a691f8c25be423bc21439ebeb1d33d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f830ad8188d296cca2cefb37996fe47e91db92ea863c0c531333e142e4b0e1dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb64f8a42c484022ee423a5f75701b3439741270d47c2d49493f753a0028860a"
    sha256 cellar: :any_skip_relocation, ventura:       "1482ea1ad9e87302ff279d369fb99af4c31256b11c6e568c2d9a9d61368ef440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9caf931d113947724d16c7d6e7e895d0002ec989958b016e96c8ddefd64933c2"
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
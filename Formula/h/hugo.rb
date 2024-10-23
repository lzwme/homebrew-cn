class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.136.4.tar.gz"
  sha256 "839e4545454396d6c6d9a5166151e05fd8f815f36efb2743b9cc7bdb614205f4"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c29ab0f25478c5c4d1ae3846f4d09b9a6ca0edcffb69773b512822582ccd5a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67967f229905feb9529c4f545ba674f0b29c56cd2f0e045ae7e9919f6a735526"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "036342e87d07d1d22874fb31226c9d7135d8607cad7f7524a326d8013beb4f78"
    sha256 cellar: :any_skip_relocation, sonoma:        "661dc3f4fb4a20cea4cad97631236f4487b1980629ce6ac66fcac956f730a89a"
    sha256 cellar: :any_skip_relocation, ventura:       "4ce42965d9ab5b7fa90fe3c803e13a9df74f34b9fcbfd0483e40d93be23126a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a705033520df18f247bd9075afddb0960f3bfb54fc9010a262cad0f4e5fac0c6"
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
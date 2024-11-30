class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.139.3.tar.gz"
  sha256 "8d83115df9a540b87817bab7615d836ff7ed1b3a80a3e8299ee7c2d3d4cae197"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f39ecd7f4826b81664d093811b60b1f660556e476a6490d6bd1e42513e897784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec13599af5a12d415bc7e971ca16743ca3a18db82e38dffe8266ec9f7b640b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9491f405fcada4de43655f206148052318fbfaf88fd57ccf855ef35539a08476"
    sha256 cellar: :any_skip_relocation, sonoma:        "349104d4297e6851192e3f4ebaec57a3e502b3bb95315427d35673d25607b637"
    sha256 cellar: :any_skip_relocation, ventura:       "a193a188a98da047e0e2b5797c1048354e22796b4ccb9d1600b930e63d053c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb1d16f4c6d148d4a9ff85822cbe26203fb60cd5fc4c5f3ac2b3f5ccd4acaaa"
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
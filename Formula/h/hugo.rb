class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.134.1.tar.gz"
  sha256 "80afac90325715aaafb95160b19c51b7a46a3f5892b4fea2f938dd7b734ff309"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaf87041fec3ba897f98da2742a98dbb083f255f2794eed197aa199decb646c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aff3f51283af23c06933144f9d23620b43f79a13103ebc9123bd2c2a536f1ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69542b4b2f4d4b37ecb2db0dee42884a2d88eab53bacb66e1c73445c71e17d1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "35de5fa2411463aa9471cfc67debfe7642ce58203344486313979192eb3e7495"
    sha256 cellar: :any_skip_relocation, ventura:        "b665c0d7f44fbe7bb8bc68ce2849710450f94b118cc06f6851291904d468fa44"
    sha256 cellar: :any_skip_relocation, monterey:       "91fef4be9f3285d4c58af6551d1d81fa690c14eada6aef176217d12663560796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42792e95ea346aa163f0eed98c6858c8cc4541fde991ea8c396d3cd13ab4ebfe"
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
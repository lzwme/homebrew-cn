class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.144.1.tar.gz"
  sha256 "991b59b293c63564ded2d28c1e6f49fb0114b6a47df5a94d9a5f49f82c9e5f00"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d084f6997918b50ac7631b1e55e3620364367e49eddfb7824dad99b4be7ad43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e28cc727d4c3b510815dcee138ca7563c82538000943fc07dfab0553b187b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "996453d71c6cafd7746ea06f48cd2d4a132c8c5e99db02508aa538e09a515333"
    sha256 cellar: :any_skip_relocation, sonoma:        "582178c7a643c53f41649ce59474d2a64a2735e5e9533b53d725cde675dada74"
    sha256 cellar: :any_skip_relocation, ventura:       "df5cadf7333cf3534a360f8c8a686065a638a2a2a8ddc20bb156a420da93dd0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1330285512b7d4dc4bfa38ad75adc10e3f94097d618d536891503e76c7360c0d"
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
    assert_path_exists site"hugo.toml"

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end
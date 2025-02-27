class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.145.0.tar.gz"
  sha256 "f6cfcfa4575ff25a08e68b638367df60b28e28a7917471c5deec6396eae26ae2"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25693c8624c76731849a689e88af1bf7ac9e086c358e0adde8b75054722eb20b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d85d07ee4d00dd64d31a4ade9828a26798272981e12e7e47edcc42f13ea147e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3eb097c9ff2d02bc7d59ac4e46999c8fc788577e701ceec0b77b11495fbd1bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0daae82eb709975f8dfb13a1048ccb0c6c7f7576b19268604a79573f288324f"
    sha256 cellar: :any_skip_relocation, ventura:       "2255b0f88962574a13d1a6351fce46f600771776147ac69b33eb96a0447a49ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e47a734f65316b533d1bf1fde615a175b13fe13f74055cc33baa7afdd2eb09"
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
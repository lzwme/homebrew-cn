class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.146.1.tar.gz"
  sha256 "6dd1ec2edab3b5f0d3c9da3950790212fe3a29e173de95bd7ae78d3fb880f050"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f0daf78d1cd0dfe5f6b238dca405fa981e460aad8a76f9cc440fbc760671c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3293baa52f6228c40ac3e35be34ad6011aea80bdf79e7e4991eadb112ce3311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dbd9ebb9dff64e1c9fd8bd4ff519c93dd0f9c0694586c3337efc254ff50b1cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "77e3ad6f834c3ffd330001510fb0deda4ac01d760377e084b5941f727380dc35"
    sha256 cellar: :any_skip_relocation, ventura:       "ea19877b0ad900e345bfcf0fc7db3aab62ec367fefaaf6a00e77e345b3fc0c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f34d05a38934f2989f201b40d29e533e5b390d8f48fcf1998d0e6ae05cf668"
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
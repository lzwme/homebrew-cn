class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.137.0.tar.gz"
  sha256 "641133ac7cb3ddaec76383ec5ed023e26e652b3c4aafd8eb0ff1ed1995e47aa3"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c78a8a598b8c5f5227c5b7b7e68c4d30fd7e9a8e0aa24809fbf7b5f9fa1056f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9aae9f621c58aabf226f27ae7d6fd1942265622bd8e31d76f078de11b864d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5b6ca2c45b0f87f907bf68dade40a1fd756b07041d7e2f930af6b1b5875c4c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f094fec3845ec5bd88cb59111a7f939bd3a0733f3448caf17de50082e53f06c"
    sha256 cellar: :any_skip_relocation, ventura:       "0f2f4876ff7588e604e30ffc50cc2922e012241847330be82f83bdd6d9a30552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34480f8a9cd43c6f5885a9a6ee1a923c9106e44f10314c94fa1238ba3bd7e26"
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
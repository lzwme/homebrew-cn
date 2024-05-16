class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.126.1.tar.gz"
  sha256 "b7e1f393977bdf6275cf33dfff6d1bcd3bab4895e7302c8fd30f05556b13a6ad"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69f373c8d9f51baaede854a1c3dedd4f802fcfbc6de51ad72b5d2a53f52d0b41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b98bdf7d574d3cd62819122621517f5dbaba879be294ead8bd8fb7b89e41892"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dc11ab7bde83afc3bbf508ec6e0f420320bb877eb41bbec37d84565a405bffc"
    sha256 cellar: :any_skip_relocation, sonoma:         "09d0b42fedeb2466afb16a3476026ca371e0fd6df0972a46b4dc85b293cfdd2e"
    sha256 cellar: :any_skip_relocation, ventura:        "11452a64999cd43d5ecc25858980d31b8e595cd4c8931e157aa152cab7422c46"
    sha256 cellar: :any_skip_relocation, monterey:       "a824f36d88b4a3a267121273b4e5bec17650e394f611df66d57c802d8b81fe1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2919c05f20a1ca8207eb9ca203f0db523f5589b8dae007438f6b435da9537505"
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
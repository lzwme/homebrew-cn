class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.132.1.tar.gz"
  sha256 "189c6b62ec4ef2adb75be27cdd59efd7ab123d04fe291e601d873bb5eae6e4d5"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbbae64b3664e553f3157b952a9dc6dc510ff65eb385255ed1c92fd299a05cc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5a62f39a64bdb9a1b726dc16dd2aac722b791fced68c2dcd7a36f9bcfc407e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d626149d7d85eebc03c732c27c7f4011a60dcb33a39b9789701e8cd649e0c06"
    sha256 cellar: :any_skip_relocation, sonoma:         "c074e7d4f6f5aa74b07d54885f78b3b9a8de9c4cc60bc42d686936f7df2003b0"
    sha256 cellar: :any_skip_relocation, ventura:        "2a021b80f149b8c804d9d9786e819206bb1b4fc0b06b75b838089c340ee7e023"
    sha256 cellar: :any_skip_relocation, monterey:       "c928fae0981a682564a3476b3a76ac59898c0d56c6626404847e24956a2be6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6eae2bdae3eb65ec2b1775a8e01a15881afa779eb6cfca1e1639a6b670c6dd"
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
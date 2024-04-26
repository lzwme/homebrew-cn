class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.125.4.tar.gz"
  sha256 "69837126d7bbe720f09c35fc1fed4f525b982b675d779ff2b18946d2e6a1ac87"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92ed6ad7c14387830aaa801e7abc622e12969b891c0d17d7f99ac6f8512c274a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "356e7edaf1b022d1c675b8d8cb0545a52910d0cf09a457a41092aaea6792bf0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100718b63d2d28e7ad572b3d14306e0b0dfae173c2d7286cfc08676f552beb42"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fd7580c071b1ec70d564f91460f0caab467bc9fbf3b75f705d3ecf14d98f0f4"
    sha256 cellar: :any_skip_relocation, ventura:        "bec6022f44e3b1bcc8ddd97659b25ed607b19b6c95a3873990c7ceda9f4a4b46"
    sha256 cellar: :any_skip_relocation, monterey:       "7d2b66c1619a1f155a263e25f2b003f7351daf6d70b1dc8f237b5c9033040e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb7759d7cbb6cb5570bd0431bfb6b54182232ddf0251f87e917a5f9c419cb8c"
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
class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.115.4.tar.gz"
  sha256 "1d8ce49578c37a9a902158834841a9bf276b35abe1f67b7b6b03953e7050998a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "872056668638081580bbad9f70e8ced45d16d1a080b472730a83e7ef939529cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c77224bf0b320fb3eb03a199d7229e7a535b030bb39e64b037ab5940bcff7915"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aec387d00cbe2b7cf656eb45f4ec9d112ef92fdfe87f675e7cb6a2fa15d84509"
    sha256 cellar: :any_skip_relocation, ventura:        "2685b54fd3ced799cb46fabe3d926d9be1345f502a5a6c3a217d75bfb27f6d62"
    sha256 cellar: :any_skip_relocation, monterey:       "cecaf630020c8dcbda492329e4d55f7ad63dbe77b7df1ce0faadae689b9d5c3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0015153c794c3e85fcdcebaa871cb1008c2081470535bda56db601cd94a60925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c150abb54b7e3ea708cc3ccc80a3ef4bb5df103fff76518e60b33130985c11cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
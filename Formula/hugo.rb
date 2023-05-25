class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.112.3.tar.gz"
  sha256 "24720523cd4feb4a746fb1462c4ad0b1ecdd4c3fbe08469d4498ca0647b9e28f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04139e3a9de5b8e2b73539d68ccab1e9f7919eb02b4e49566edb750709d6f939"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f52edd73b5ed3f72de51ad04a0c5d389e2cdb5856c7959b8a427a4780ce8801e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d25f7e680155bd89263bf17b9748bd786b51154a139e8cfa23b44c7880153b6"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca0415c4be4342ad3fddf1cf1b7f93fe47ad3c1b704ed4c3a973e5a855de48f"
    sha256 cellar: :any_skip_relocation, monterey:       "be77def24cb4e299e591fb80076041e1ae9784b301e651bff3ca0cd905a242b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a270cc8e9d2b1e45fdab0ba70dead99808faeadf6927e7d3482e7d62eb9f79a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4da6a1ed2baeacef15ce1e2c5835b631ab5acf0e62feda2e69d44a527f4f19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
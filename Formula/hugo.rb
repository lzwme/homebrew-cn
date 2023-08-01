class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.116.0",
      revision: "5a7e0da84e6e3cb74108abedc0b3331cbe2c9c68"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f1a34cd5d1cddb8a30687d810328bd1095a361d767a7f9b77658b293dbda98e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a49a6020d3d36851f6e08ebc2b008264726f92c079403c8a7be8fdc5827aa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "048275d4efb20287893405f681574c7bc49b144620c5a4678b30d270d68ad92a"
    sha256 cellar: :any_skip_relocation, ventura:        "532c80999e7cd577f08f27fca7485bc10b070a499168701d53d657453d4b364a"
    sha256 cellar: :any_skip_relocation, monterey:       "9012f82fe40982c7be9c8b58eacca1f1a0ea7a5b59d5ff432711b11a8c75c36d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f913ce9a13a0dce23ee06aa54f203d1edd26f057ca398f63e1314c33eae0e87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9412341426533629e99273f6e9724d87d0731317c16864f3f096d20946a8c5c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

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
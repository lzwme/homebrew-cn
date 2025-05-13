class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.3.tar.gz"
  sha256 "cc37a9ecec5f8065d1854916c317015fb2b6e8ecc391db5a04adfc3818599152"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab459e598537ae4077bce74b71ffffb5c7f64b6be37e9ee3c8b0d8e6a1fe018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946d48a188fa8026de41d70425a8a39149977f7eb4e41d0e686fe620203f6cd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c83e32196b6df599d716431c6d792ca2b4b0e418ae5e3f95c2d2dbfb9fc1e29c"
    sha256 cellar: :any_skip_relocation, sonoma:        "34db8d7ad65a226b9d55ab39e9138c41b8f7bc5bb1b848cd8efe9d7c14c2f6d7"
    sha256 cellar: :any_skip_relocation, ventura:       "e17d359b4b41510464032414e6db3c2c9cdf38a7f63bbb7636aa00d2252844f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6fc0644dcaeae92b974ab07a2cb54a2a5a47b47c253a8a2a657446d619995bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ad002d74b49aa51be3801e8deca7686d0bae361104e0463709bfd4c585c4e4"
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
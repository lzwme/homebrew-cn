class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.125.1",
      revision: "68c5ad638c2072969e47262926b912e80fd71a77"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b12d879d2b997ab691f99a1fc7758a1945b4e0e419feb9f2192ce18e03ca97ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ca8be9bd303e7f830ba3bfc9aa301377b2e8bba8fbb50cb175b10e07b92b5a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64f4c2232cc7535ecc95e402b519fd472594a8347bb951d423900a58bf8d3f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f663955700c5e4bc53bf07385488a2175f2733cc1b4da04d36fcfa74d39b502"
    sha256 cellar: :any_skip_relocation, ventura:        "f37c8dde84c5cd34a80d3fde4664a3e16710d9075d2269519bdcff58a3007bca"
    sha256 cellar: :any_skip_relocation, monterey:       "e888788e0a8982fc9e687357870754f41c6c00a230b9fb3c694c405b319828d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52b1b111f0839649ca0c0fa402f0fdbcbdef7647f1cf8764c47fff1412991a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{Utils.git_head}
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
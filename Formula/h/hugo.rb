class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.137.1.tar.gz"
  sha256 "ca3bd3099f0268c43e6cb5a0f7ef1e49fe495d9f528981778047851ba1180c70"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "836cd53452a2578deedf7642e19db6d64d02c55d858d181d6622884225728c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0baae9ae40fa18f79d8049e17453dae6bed36861189f8bbe40d94237133e90f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "900ed088a6b4a4bd002f2e2d5c8f0021a439dda97acbebae48765aa3b4dfca4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c953dbc4eff0797bea9cd15f4879d401bce2473b4ba8c3b35d4dc6803b2e53f4"
    sha256 cellar: :any_skip_relocation, ventura:       "9066affc99a76561a8e43565e44f04a6c52401a8abb462b172a8165fe5378635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25706689e8373ccd421c22002baebbd676acc0614c6686a7ecbe11b4ec8f055"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended,withdeploy"

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
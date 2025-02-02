class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.143.0.tar.gz"
  sha256 "0fb1995d25c379231ac385b64ea473ab0ecc1f82c7eac0f183b1c476d374c8e0"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6b0fcc18ea05fbda23804b8a4629bc7ada3519fc42abc1bb3e189c1d3cb9e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603fa5f55bd0ae941817a3deb099dfb802895d3795c29e8b4fc702dc538a5267"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d7c0341cf4e9c78df1a401add81cf5410f760e0daee264ceccf3cdb0448a3ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e32619d20f7df35473f2afc0364b622709889b734b98a6b7270610c0fcc065"
    sha256 cellar: :any_skip_relocation, ventura:       "e926878be677f0cd9392aa558525a335010af5a3fb161843bab4217ec6cdd083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4216157c2496e7203247ea85dba5b3341fff09e0a3ff6af27e923a8c65ee87c7"
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
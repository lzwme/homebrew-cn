class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.134.2.tar.gz"
  sha256 "6052a0c059e6ef1ab867c8316988b260ce422138a7550829159b23d2296376e0"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3cb8510149fbd2e713c404b6f21fc3cee8ff7a5ae4868ce8a65205a6dc4e25e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7dbfc9cbe97e97f47758a2467cec803f04bf27a71612b4a1b5c890672fbd6c81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63ce4d20cfd04b279020f3de7b663b38ba247a8a1f7a9f2f3c730b5716be7575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa2c705f370d73d1ec84d4558eb93aad5b22e28ccaace7049628ad66382d67fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "114dc785d5d2e94d599fb8e0bdb5832766b76d9c7bb5757495a6326439f0d382"
    sha256 cellar: :any_skip_relocation, ventura:        "2c82bd4f155475a603dc45513779e98592feecb86efb65bc49c25b2a0fbf9102"
    sha256 cellar: :any_skip_relocation, monterey:       "f55de9e56ffba80db7902bda6ce38e990caec7c3dfc88fb4a6eea39cb0f9b1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fca93a0ffcfe431c29fc5015a23df3fe93d04925d95f4b9c29d224e9094544e0"
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
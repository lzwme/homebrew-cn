class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.128.0.tar.gz"
  sha256 "7ee81aac980c23448d9bbdb387ba61ad3ff80fa13e39e9787ebfab9e8cfa0b60"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93c98120c4ee5b3d4eb9685d3da5b7c4b2b6aa1556e662f871732399b6e4db40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5967dbce968a9e7a75ae5ef77bf2f2cacab7213a41f9a40ac9318bd1bf1f7d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92f72037485d72fdb18506140a450e4deafa5f4dac7d2a46c961f8bf829d3c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "47f4916fcac479a7fc956a5e07a2135fc1974e5a486f90f80074341db40f61d4"
    sha256 cellar: :any_skip_relocation, ventura:        "b08d6166dbd600b5a62364fdc8aa402c518e35b969522c4870cbb3fbe090de7a"
    sha256 cellar: :any_skip_relocation, monterey:       "954ac6d66604e46aa904b00f856eeb0b063f648eb6f497f5f4980ae5fe638ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac90ef5704727805a7900cbff70a263b7c0003ad22f2e99a27e1895fd873db9c"
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
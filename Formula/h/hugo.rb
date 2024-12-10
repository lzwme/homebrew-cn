class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.139.4.tar.gz"
  sha256 "8c89c968ace21086528a164cd9a1019809c0064f0ea2ef8a82b035c2d079d19b"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7cb9b14c5ccfcf071d125a45020066a5ce73ed3c73bfc3b39721a0ce36676aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad1fec7b0011beb6df8bde30a0b3a45fef9ea02dcfb7cafb0d158a36bbbf40a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0e6b4558e55e4494198d56ca5115ba122bb904cee309426cf92b16dddf37fa4"
    sha256 cellar: :any_skip_relocation, sonoma:        "816f011bca92fe21f4bff2574f35151fdeb234003640814eae0e036cc333efbb"
    sha256 cellar: :any_skip_relocation, ventura:       "00bfb6c4000ae1f5e7235e083c66cb895da603f8bdccf808c4e2205f95ef08e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d493c316eeede1cf0547a5495ee0c5408d968d3cfe18cf1f7901437d0f18b387"
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
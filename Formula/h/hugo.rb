class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.136.1.tar.gz"
  sha256 "7d822d9ef777bd97d9d46b42ff8ef1fe9c5f3aad6054759d977c749c711f4be3"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6afcc0fdaa39c07262099732ac3c8924e26fd813ce3edc32c68f7b120c2675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1926e06d23daca377da920eace0bc24f29c5697e8df310eb75d3a2a8d96e8fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c72bbbf91aee41006a5d13da8b64c8421ff888d53d2176709b922da4a312a5bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6708aecf19021563d1d59acd65dd64f10e08faa4a98ab2d8aecb745f6a65553c"
    sha256 cellar: :any_skip_relocation, ventura:       "c59d94346b512ca797cb6b8a45522dc2c4525e166c1ff3a629be027850fac892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdf571711fcebcf6cf0ca2eb4ce71240d6cf7171bf0ce0e6ea0901d1c7a6b6b"
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
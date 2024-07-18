class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.129.0.tar.gz"
  sha256 "e78d43b8c1570061ed965d72cd7dc4cd7c7cfc176e7b591e281586ffd2749685"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93b92fc944623c141858f4ed39a603decebaf607b5cf85345ac4361146a3b335"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13fce893786eaabf71f6e45ff7dad0c7ff98f594da256227751cfce47cc8b942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21cf7195206d01cc00f6f49f0d4562feea01c5e0a666017b2c511ce1a02aebde"
    sha256 cellar: :any_skip_relocation, sonoma:         "567897e55e3a9d9791a0c6a7f9e545500122ceafb05507ceeba97528dedd1af1"
    sha256 cellar: :any_skip_relocation, ventura:        "ea622f6858fd3c7b8d5c402eae2becd42c326e800c042dad7d1ef2366dcb19d0"
    sha256 cellar: :any_skip_relocation, monterey:       "fd50909f4afb1e4d2c17f3443c99f9488316c531f4701d486f1ce5beee950a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c65efb73389c24280ee4dd84dbee276a74d3826b6580c65c97581d01b85fb87b"
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
class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.125.6.tar.gz"
  sha256 "c50df060b9c760fc12c503a9ca53ca1daa428766715ae9dda74d6ee1f53bd0e4"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19ea37382476cf2d5a3e67121c1d27a4f68ca6f71313d5d4d800d6c6573e38a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef43cf5bfdc2b50a1fe548512f6d2556f9363b119cc631ea9ffc8d31fc4bab2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36122c51bd20bd7adc540c75642770f18a06fa13b8bb1ab956324d2e8ab2b314"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b0fc1abd0221ba3f5acb1622a4ef9ac5890c8649ca64858e5b2879be0c84a40"
    sha256 cellar: :any_skip_relocation, ventura:        "31224d8a3c0a7810a88d13630887213394f13431090c7a0d2ad089bc76b2b572"
    sha256 cellar: :any_skip_relocation, monterey:       "e0596e3a3edefd8c776b3fb5865f024cc3ff12ea53724ff51cbb3dd952ee8005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dcb2ce8bf9fd9696986fc2138225463cdc5b9b425421fae6b910373856d9ee7"
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
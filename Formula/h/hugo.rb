class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.128.1.tar.gz"
  sha256 "8f2915eea8fe8bc6ebbf7df7c5fc54f103f71d5391d797076b2c4dbe7558b169"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2540ebb1a9f688ceae1b33b58200cf33feb5b1d866e74b27cb39cfcde2e0635"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7113d1efe4a0b8b0ed1c5284bc1daa89e30b38b875d8e5b12de1fccf4890e75e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f48b99c681ba94781791821f8a2a0c3237e8f8c336ffaaaea441de59c35f9a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "835b1cdd8d837e4e2a189968eb90426da8a1c5b1fb27100bf945c59a3f0cdcd4"
    sha256 cellar: :any_skip_relocation, ventura:        "da9f6a2da1ef36f6c93ec198baa31e9708573d64e2f36dcf0278aa697794ab74"
    sha256 cellar: :any_skip_relocation, monterey:       "9fd86068221c478d46b7d4d4fc92a3b23cd18b5a8ab8b41a4a6ed59e55bd6a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b48249b15c4f4a12826f1109af68d01f56edd87a9de302e99a6014caadf6eb"
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
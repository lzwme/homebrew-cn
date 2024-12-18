class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.140.0.tar.gz"
  sha256 "dff0c1e8142ca9b477f3c3b001d677ab3d90151674bab248c3685dc4b00f7cad"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52df34a773507cf9f195e348688b25e486b756aa51da78fe38187ec60e72837b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee3c3d6ec39b9c5e3b2e6324a6eebdf208c360cfef5ce5b897beb882082a227e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "734dd15d54c59a46ef2e6043ce313022a495e7b1b43b89d2341cd9633573f55c"
    sha256 cellar: :any_skip_relocation, sonoma:        "356287e3a871402995c7af2bd1c550cb1a7b202c83c7ce68140889471596ad31"
    sha256 cellar: :any_skip_relocation, ventura:       "5ee7003a3d11a0a85e6ae826605b5acc3d051be7f4e9adcd759955e0710c967a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11a9f6674e2b125856964aabf3cdc003eae7da6e090b77a96f43bde8a4288db"
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
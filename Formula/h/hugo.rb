class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.144.0.tar.gz"
  sha256 "319688f8245fc31e185a19acd95a1b43e4832b533c3dd52631d970dd0c810707"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75050457835a937031d51c83ed2a7726ad5a2ee4d6838f13170ff4e767dbf3bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94cfd2d8a2051493d52db714655aa2745758e618411eae0dd3aa7f6a4c328075"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "617ff421e5312abe8aac0ac9677e70e16ef750128fa37aa9acc04dc953cf53de"
    sha256 cellar: :any_skip_relocation, sonoma:        "be24be40ee4edcecc6f4889922cc16d04ca1b6cc607bbaf101539de69119fd4c"
    sha256 cellar: :any_skip_relocation, ventura:       "3a2e752a760a9b6a61b9d80a3c995900e5c278c5cac2e260582775aaac75d30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f50e8a5bfc5a90a5e5d0aa2369765b7b80616be3510a11eb811008ea4493f42c"
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
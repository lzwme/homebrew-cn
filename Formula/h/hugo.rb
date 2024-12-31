class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.140.2.tar.gz"
  sha256 "45594ddf39d62d227cfd54c19fb9a09ab851cf537caee6138de0ddd4f1f6f117"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e7448dbc5297a6404d0a7327981c5bcc11e4418c0153a918931c0263c52ca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2917877b59785bb482698f38f7bf98dad0492584de751aa95393216d1091ea63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ee1fdefaf9a85f7d2a606c3bbcb932d64a5311b906d2b297e5f31a17cc1d3ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5f31ef480f3fdbb37793afa7080d56cf24703a5ee630e7dbae81d18fb1144c"
    sha256 cellar: :any_skip_relocation, ventura:       "7a081526f29daf3b35da620400f1f519b7eec1266a551956be8be0f815612cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6850ec613bdae5b61fcdde4563a581d53d2868c8c4f5aa53343aff135b99189"
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
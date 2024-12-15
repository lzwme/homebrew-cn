class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.139.5.tar.gz"
  sha256 "ed3e3e8887285c71b5d8ae9f9be956c5313c16f31c8501602d52eae7a002f53d"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b62423fd9988b8659791c0d2eeb296cef613cd6f076ab12a60defa47b94364c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9654fc6e0a47b815818b2285ff02a2f7826448590527ec4baeb73462d9e2b3bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bad27d30575310b95682b0f4f6b8443e05ec2c1ca405cd7e8a29dec864cc0af"
    sha256 cellar: :any_skip_relocation, sonoma:        "746766a96dd88119bc3cbdebf368c11e69b7294c2f44354e16f076563a318aa5"
    sha256 cellar: :any_skip_relocation, ventura:       "7ed1e8a2e6880fa7999bd5cb3fdf2e574be948f098bd6775e0cfb55fa24e7477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd53ea7969cf378dfbc952d1450d3217218768f8d7325e15b92097d6d976fbd7"
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
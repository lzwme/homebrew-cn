class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.147.5.tar.gz"
  sha256 "1decbe0a09065398c81810ddf929eaacf9747bf7bf9bd2acb795c2394c5c5dc8"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30db567383265c900ad38d24d8be26f8da35003a80cca4e45499cae81342ea66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12523d6c75e8a36177300f77caf9aac64c98888db55d37b5084feb32ee41856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3f5c5513ae6ba5d9b688013cb7553d635075a6cda5335e1a0e477d02a2bbc8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb7e866c6c4f32f55c72674e351b1930db12fb59fa029237f0654345d8d6e00"
    sha256 cellar: :any_skip_relocation, ventura:       "a6f042df74f13f81908766928428a5a6dbffe5b72692cad150717a51d88b7ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bccfe40a2d6b5f607f124c8ba5f33a2ea5df77dffe7d316635b2f00359d55d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be811dcc4571dcfcf4dd1dcb21a64b708ccc46245fbb98dc7003c2a39ed88f99"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_path_exists site"hugo.toml"

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end
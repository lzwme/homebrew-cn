class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.26.0.tar.gz"
  sha256 "135a84eba084f7d3fa1df3eb9fa15e5a27908c8c90b3b914795f5cae7cdf672f"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86f1d7f970d51fe10659685cf98f5196174c62cbecdbdf79afaff635c610036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526526cf062b77c405f7fca2949fbfd15ffb2504cff8596655a1a17dd8633440"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "682181c7a59e3dae33b67802e08afcd1fc31d6a17b46e62dc8d571224d384afe"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7e106a3555b403e2204cfb1a44ddbc11043ed023649c5e381e38d998e8f1a9"
    sha256 cellar: :any_skip_relocation, ventura:       "52cfb5707c21951c15432aadccf67634e4a9efc5f5230e91ed2c8aece4af06a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fbb19be1ec6059e06dc8969145f110a35bc0b153cc1721efe494a3199580810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fec47b45cc7f2e977fbb5a1ce30604441c50da624ca66a6f7d2bf819d81bc89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdsyft"

    generate_completions_from_executable(bin"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https:raw.githubusercontent.comanchoresyft934644232ab115b2518acdb5d240ae31aaf55989syftpkgcatalogerjavatest-fixturesgraalvm-sbommicronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}syft convert #{testpath}micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}syft --version")
  end
end
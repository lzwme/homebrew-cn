class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.12.2.tar.gz"
  sha256 "457b9c784518cfb599cdc71e14f368a715065bcc2e476217e877ab278269ec26"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f7ef4c4fa807edae9a325947580d59bf83bf9a41a9e6b8b166cf2dc25478ae07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d365bf6fc614c4a8e89b02922e69582ed7f7af97a207f02db76385523ad99b20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "554f4acca54497439fe2e839f28a0e17b2977688e0905168f933387d2cebe624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64be180917f4a48accc13e8ff9c8af97bc67a42673c71eb2514989b3a1a8fe98"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8874c772b53f85085d1c3dfd282719f027a678bc28964729ce02d04dd2aa396"
    sha256 cellar: :any_skip_relocation, ventura:        "dab30934e5b1101655dc9bf19b77d094808863d3ebae4d3fcd2ec7b7e2bab0ff"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a5fd8a7352bf533492f7b3a1137f3c6b77d9d971618c2d003b534067d23511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cad35968bdc71a87f4f5bc5fff8cdfb8f8a9cad6f1588b880f8866af8db22ef"
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
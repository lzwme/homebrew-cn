class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.105.1.tar.gz"
  sha256 "dbef62943fe8f69e30982c7990b0b89cfe4fd409221697ddb8b7f861390241f7"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a027963cfa125df69d3993a0027514e9e27fc98b13bcc98cca34b45cc5b05f31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbced8aec3ac165f7ac65fd60e5361c45cad12e8d8dc99a08e454c543e42997d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6cadbdeb6d4efeac6126241f28f46a11463fab7e0e2400ec4ac8b1eec303e8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "001c8e80381e5bdcca6ec76928b04864f27bc60ec750270bd29e09a4a0742eca"
    sha256 cellar: :any_skip_relocation, ventura:        "4040595c6c6e1e5b3f72f4c825aa84704319f253ada8ec6fd1b098c7f96c002d"
    sha256 cellar: :any_skip_relocation, monterey:       "2056704bb7327e57288112fb9f840bd9f393736026b9c5ce0feb1ef3c084905b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e8428bf2860d3afd02c3a84b6c8e84fe1f7a67d470f7e33f6d8487110bb5d91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdsyft"

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
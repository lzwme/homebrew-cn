class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.15.0.tar.gz"
  sha256 "0e98e7066725ac2aff9de522aef2ea46b40cc2a5dcaa076373701b4bd4eac2f8"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27fa6313d03f127d7e7941aff95ea3b5d5e1ead8940a032111ec0ed75cec4ee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b343e741537b860486cb4c818ce4c258546e6cd03b7e1101b15c5d67564630a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a271ce0d3c026e38222e99bc6eb6c99811b14e959a6110c183d6c6c39eb198b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c709ccf3bd395fce3875fdcd8913ca99b5a8e93779dff8a4d0cf1cf79b007e"
    sha256 cellar: :any_skip_relocation, ventura:       "85ff8712b0a8be91e3f804a6123cc4a937187239354b5c8308bdad7ae65ecf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3109aaed33d10fcb78520769119f10a9889e8e349d87e7bb96233bc0ff9a278"
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
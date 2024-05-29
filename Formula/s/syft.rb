class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.5.0.tar.gz"
  sha256 "35591aab6edb4c8c44db4848cf1b18b7a8a47c3c6be4a8b862e493d6b537cc3c"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "980ded2828a3db6f2ae4687af110b9eb73707c9c12eeb27fcfcf9afa80ef18b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac7f1e805ebfebbbdeba45733ca987833c1a1d975d3f6311d2a5f7146e8846a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f978a1cde167924be0db6240d55b65b990e12eb9eff55a0f1695d5f181ee6e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ea56b59f9397efe4267123bf4416fb6e3ddc0239b3f8792fbd0f1b0c90c443b"
    sha256 cellar: :any_skip_relocation, ventura:        "3155122b00ffcf9a3f5f3395e623d8f8b8de9c38d3dc65d07880148be34be88d"
    sha256 cellar: :any_skip_relocation, monterey:       "f39f009c18b8566317fcadebe9dffea24701b1a086578fe9feb36279483d299e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a403d659deab21fc39e98818e5356a8458072790edacf54eb0f7226ffd4fd58"
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
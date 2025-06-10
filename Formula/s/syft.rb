class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.27.0.tar.gz"
  sha256 "a11cc41fadeb0141df4e72b3d330860ed29ab5430a12a92d80c1213678a3099d"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b04760961adfb40aad448c9093d60fb00a7dd58ca76957d47ce3471baab38315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b096ed310cc8f555db0ba557dea6b7ae572ece50a07128fdd4d8124f9f68642"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f59468b62c3f2e1a9c185444a4c2590a49210bed6ef11a29781fc98914c91d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad5f5fc04e9c4e56d653a85a773bcbb7637859080e5a6ee034bcc652d43b4bc1"
    sha256 cellar: :any_skip_relocation, ventura:       "cf0f744e03cfc625fcf89818f6b6fae26444aef3a9b020d97ce584dc4fe61bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2b7ff3751dc134d6c1832f3744e2401c79188a6e786ed9818be49aaa00866a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "983993fd032f96f6481ac5bb7550ffa28271cd24e8764517f7e761b93b63a728"
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
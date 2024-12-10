class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.18.0.tar.gz"
  sha256 "293c69b36f1766764030fc9ae733cf4cf2a979d0647ff97295d0df61b37be4ae"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72418e9206bb2d312ff6bb66001312ce9df6688d11c1feefdf362a0552467c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a91ba111817ea51fe42300a3ebb1eb91f20b94ec151f8a6a0eab08ce70775f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d58784ac2cabd7dd3bc55a1577badde8a6e6d6baa8c7e93bd0c27ff4f58d76f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3065ccefc1063d7232ba43b142d16265e5ea7e90d7582d65a27350b437f2a062"
    sha256 cellar: :any_skip_relocation, ventura:       "416eb690083c41ce836ce6357eeba854f40828180cf11ca770c5142925c2a353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d313215088161af48b5f3b0c832fae1da51b2054a4147652fd2a09e5ae0022f6"
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
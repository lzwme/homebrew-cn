class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.101.0.tar.gz"
  sha256 "6b36bf53efd6fd13e5162930c4902895f0894dbd77be7a5277dd11412fec994c"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6bc9f30f187dd0ceadc71687959f4c2b8c8b9b61885703308d53777f80182389"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dd59d2d4ec60dd08108d6943436ab6820f3e4c85b9b59c0ef3c2b5e8865e80c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "deaa308ae9df2e807b66aec44b1f1368db322a643f94bfda9d37ec17b651bb1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7dc8e59d4fdf5388ac38c420ba13bbaea3832cde709fc1aaaed078adfd3108f"
    sha256 cellar: :any_skip_relocation, ventura:        "e8c2785ba4008004ef3495bc0dc34d76b4c8355c7d3d38894db27e0ea36e1533"
    sha256 cellar: :any_skip_relocation, monterey:       "a701fef5df3bf9f814ee19a375f8a3ac35fadffc84fb4b1b11f3f019bf007811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aad9a623cb2fbfcd4aa8c99061bf117899aa092035ca9958338763161c56a07"
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
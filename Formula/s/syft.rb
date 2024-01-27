class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.102.0.tar.gz"
  sha256 "8f03eeb09be052272bb71db0eb6640ead9bf5c6f4624e28dce28b91998ab393d"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b5f355faa5b86885ba59a741030a276eb5528a71b62a0f79600824675587f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6256bc093a7c172e42489626950e985a209d43abc2256d71050ca83bb22383e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "859fa98bc2bf903741fa884b6d4c370fccad1dfb366143bf4de1a64ddec67bef"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6d62e68113781404a01da0e3bb2e1d0dc1f12f5fa8a27b82626a28543612338"
    sha256 cellar: :any_skip_relocation, ventura:        "8be25f688231c93aed90283d178331dc624f13083e4e14ea804ece127c13ee74"
    sha256 cellar: :any_skip_relocation, monterey:       "63f9e3b42a22874b380e689a1598efcbf6a3785d09642e816e9747e6224d7311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84f6d32659996cedcd7c3e223ba78f96b00982d500841067be314c8f5c679b2"
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
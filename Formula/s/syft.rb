class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.9.0.tar.gz"
  sha256 "a292dd458bd8b323577306b27d57cd69ab3fe43d817c275edeb4f0c67dbd38e4"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a95dae0aca9843c9ff81c75e0817e7b6b8e278bff556beef6b861643774ff82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "554cc87a42deee4446ebaa0bd84b1e88165da9e3445e6a8aea02ea0affb42c02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f03e0534b462f89f4635c71bb6a29c6db0adfe9dd19f6bbace672efed41f1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3c64fe65647c3b5ab0752e078f9cf1130cd7109f6db5d2728386fcf791ec613"
    sha256 cellar: :any_skip_relocation, ventura:        "c1e0294600d074d03b81b7b1f18417da04fff03c4993937cc3433f1f80e2e29d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2580c00142f7e7827e1100f4c1e4f9c9f6a6cc8a0095b0fe322d4c2fd7c30f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13b033a3d04f72548b2092f56b6e8f2532cd1fa1e87fd87ce9fae909f2a69bd0"
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
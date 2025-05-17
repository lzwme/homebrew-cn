class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.25.1.tar.gz"
  sha256 "6cb1052356177c1a6972122d7c6395448a65b49f548f63303bebf45965810733"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "429ac677bd32c3292b8397204fa5abfcd1000ca65feb1f313053c3fe1b615fff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e5ee58a9fef6de44cdd75575dc908d9f3682999f5fcc5d16fe1475d30675ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "577fbd76fd638c361b987a324fb79f280d776d6940b471f251d2b54c19f69497"
    sha256 cellar: :any_skip_relocation, sonoma:        "8339280e6c6b93bc3037a39abf51ffeba3c821425dcf3b4d7b451134e308f0ce"
    sha256 cellar: :any_skip_relocation, ventura:       "d24d8de0a1aae9ecc7d0f7d3a710dd5b76cd83a7992088595af9078741c06a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d776fb9e1f8094043db907b4a62aca13c4b712edcbf2dfaf3acfdb9f0dbfc29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e485ecb9477392c64f34876a55abb9ed9693888ecb5017653d89c1551f3017d"
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
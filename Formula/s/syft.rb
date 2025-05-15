class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.24.0.tar.gz"
  sha256 "c8b8f66f33c90ce9a8112bf005e66971a82b84448d78bd6958b834ebdc5b13ef"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aab4d692b5c4d0ef590467a33f7dae080277a711876455a1801f1e00c3cee1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291e6873bf5f4d0d4f0f07fe076346cc44097a4b2c185c18ef3be7e3d6b4b249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3687bbfb0aff62ba41d6092cbdf40fba2fb547a251179b8dba3c339c261dbbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "36bada90de9bd2b4543188c80268ef2dcaf68b2d35ca9c2477dd1e412818474a"
    sha256 cellar: :any_skip_relocation, ventura:       "deeb44e4736fd5b83e53c94b57b41b0da386c64ff0940590605a3234b2f020e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ebc51f92505dd7fc84ce20bd2d40a54d4d57f59b0cdba24b872a7ca2918589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437b5f80a03cde4cf9e21c152ca4f1a93f88208841790fa65d85b40c2fc39172"
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
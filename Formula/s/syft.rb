class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.6.0.tar.gz"
  sha256 "636546852c7eb76e763c1ebca88df03b6ac0788269fde336f29c71ca61b195a5"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f0a91fda93ccd0f553b6792ee77fbf901a247202ad9c0e91789efa157bd83a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c36980cba4f60fac70c8245c8b627d8ae7ef0d3d94671cbf03acea8e40d2074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50300b7abf94c16847e520a544698ccd8baba015ace1a86b72f167ed0e7474d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f74226170c1c3429599f1b02e36873b2cfb1d7f560e717848b943d5af5ff380"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0b27a9a5f8df6bf8a15a30cf641eb4f3a9bda6a5d40ba8a0431836c95470b1"
    sha256 cellar: :any_skip_relocation, monterey:       "f6e5b511ce3218149fe73f918189c577b9b511dc7317f9697f5f9b399b0a8919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe18295575e9a5b8cc3b50afc37f1beedcf1f56e785e1e72f44f86d9c4f834b0"
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
class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "6140ffc92934ebe1dc931b7c7b1587a8622179c0fc01afca87565aacb5acd268"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4a93715cc599247ec5eec84405c178cefbfdf267d0311382426875efc1e6323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c719581232ccbb93242050eab915e5f523f79c9721b74c7023095bb88f27737"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b2b696a07d5604b10d4550b374f69715fb1709a3376c911acb9e379a18df8fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1b0fe1805953a08f1dadc17ed70e57a62640496e1e04c81e1d54b5a7fef242"
    sha256 cellar: :any_skip_relocation, ventura:       "9fbe97e99a71e1b5176706b66c6c7a09169e68ceea422b54a246842dd7932801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9446fc906802d83b60810d5ad6cfa4347cd486646b78704f1d5669342254b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a71d97ad6f82320bc469f7207ff7a94e266891ea4690da5a300b9aa18fdc10"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://ghfast.top/https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
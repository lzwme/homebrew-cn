class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "198965d7a6013936669a279dd3e97b744a5d068cc7454d2689dbdd3cb5967da3"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ecc95def472d97cc571f4ca8d287e32e126ad6a7d2d277365aa7a0b53154b10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "275c75529bcd28613afda4542a439d6f0ab429e55f32f0aa4e0400b117d99897"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a310f7ac4809fef3789b752921e085aeb85b53322be7deb6310ddcffc02ed684"
    sha256 cellar: :any_skip_relocation, sonoma:        "cccf075501aae3d4ec28274e8c494571735197d18f3ab5059344902319f8bbd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63841348e554259688d9a30021bf61472c9cb38e6984cb82ada10a662b9b1456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa1460d7d3eace5ee2a468c699fed5dbed8265942398861f662830ff0db11b7"
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
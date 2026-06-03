class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "4a5109461a02270ab1e15c47bf9eb6069ce25afc3546970558ecf8b1756ac945"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c184e8733a5dd9568284338ac8fcb5897caba4db1965dbaf552e408a1c23344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91eea7276b7ee6d36c6fa0886ea3d895acd25f34c6682eb63b9bca0b3677b851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b05bce192e995ee07b5925b3c83e98e2b80fc1cc97058023c6146f9a0806698"
    sha256 cellar: :any_skip_relocation, sonoma:        "656ede0dd5c501ad2063745412f9417186266ea9573f73e7f4a75cea899fa89c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "add4e7fef3a4961b2f1b7c43099bf90cdc2474567aca9f4dcc73c439574309bd"
    sha256 cellar: :any,                 x86_64_linux:  "969144473c32f414e223e4fec00c907ef95415ffcd71778f080794dbbfd3e5ea"
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

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
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
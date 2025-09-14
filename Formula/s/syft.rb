class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "bea74282006ba405da09b8d9e700b19f84e72b6fc79326ba0af8327872077202"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "286428dc48f17c472e51002094d7145c5fe8c2ba808ce9c12dadfdc5ab3003cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cf4b5b3d2f55950d4017c94855e3887c47e2aa0a1b0c862ba71ed1ceb0583a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40acd87a3531dc2c2d3771b29a797100a2bb504661123ebecfa6890b2eac396e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2904f42d769b1eb6705df157724598ac807c3b4a750639d0ba18b51cb4f207a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3787f177140d3969af2c92befe092d579e9a7cf6e278c8194c8fc434e9c2d8a9"
    sha256 cellar: :any_skip_relocation, ventura:       "b781d36ca8e350a278ce19ee4d520fe362734df9b7922e9b4f77255b5c8b8f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "451bcf1e41a5531f70692f5dc1026ac13f5a7979e93fcc050e5fed15ebb7ee1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2283af91e865c7332c97813b6dd80bf32994721f97e4e08150cd6e156a88b0f1"
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
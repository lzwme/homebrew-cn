class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.76.0",
      revision: "dfcc07e5122217ca9e2fc75817c593356fc0c405"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9db3ba7e02e8fa8bb72b940ef206bfe7a1fa9427aecefdd72ef8b18c5f427cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c10d1bfb47e4c95d81184decf8ece101dde5ddf09dfe131bb4d54063cd4998c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac8ecfc23b863eddcd6ec4f963d1ee3d8e6ffb5f21f23c163b67d95379bd584f"
    sha256 cellar: :any_skip_relocation, ventura:        "73bee0bf2183ba2b1a7b01faf04481baae850052d2020ad966a9644d691a3fc9"
    sha256 cellar: :any_skip_relocation, monterey:       "1a887dd507ba990503dd797bad6794c75d9d14c7d17fe36f14898ddae099c130"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0df36b33c33f113bb8912ab40c1bd0675e6edc9afc669d5e37bd7f32d8270c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae05805beafd502fdbf3123226e4416f842d48131ad6675859be6d0c6073e0ee"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
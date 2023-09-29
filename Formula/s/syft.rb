class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "15073d2a349ab2ebcba7e4f446016fdb6f9422b94bd59bcb8dd7839fab2e4807"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5ace7f5234269aaadded9fe95b639dd7df2575dd2def9b02af5ddd48ce5e6fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a881abf8f3fa7505e7cbc68e6c9858cbf59c000976fc94d99e433601306ccec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "189794f4501a76908f5294269aac48a1318d82e45ada320006068063801fee43"
    sha256 cellar: :any_skip_relocation, sonoma:         "116cfc5fd4d2a65d0a2773a1878f21d8b2244ad77708ce9f8fa659edb09d3873"
    sha256 cellar: :any_skip_relocation, ventura:        "906c4835f0ca16c88076e6b38f083e7960cc654c45ffa0d6e6fee91a902f11ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b0cdf0d08fb5efef779247bed501559d7d928916535cc856154941e76a6214b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "423825b67704e47605f87bc46e793ae6898c7d0d20ef3dfbd00a28b1792407fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
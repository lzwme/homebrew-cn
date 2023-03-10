class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.74.1",
      revision: "41cbbe09b205e3b80e8a57d4f7a509b5f938557d"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1b5ecc46ffdb69783a5a6c76f2337d3efae7cedefa17cdc4834ef34b6863cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81dc7b42dd47b12f729b8050243fac22a7a6f56da42952edb1f8ee7f85db473a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2810c013c2e85705a4ff75ca5b1565197bb9002e8f00af6b30a78c066d4db9f"
    sha256 cellar: :any_skip_relocation, ventura:        "5895e7f5a38e779d0f64a633b08a67391c31046e8c6cedf6b41dc0d79b58ebf3"
    sha256 cellar: :any_skip_relocation, monterey:       "b6326d4c2a7e58948f9863561e0a5f6b609670af865cf6569cecb226825a975c"
    sha256 cellar: :any_skip_relocation, big_sur:        "42307031e874f32cca726bd7fede8f8100dadd38abceb94e27cea59c9ecf9951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e968a8fc1304155659334363c0877ca8b65af1b7a46d34d89158c4a151e08cb"
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
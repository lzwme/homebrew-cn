class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.77.0",
      revision: "dd30c99bc2439cb91e3d084eb21e1040dd5a54dc"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6af5134af614e9eed34ea0a9aa38d67ed97df8ae98a9930257b37af20dc72c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36cb8345b59eebabd3102c94490263c146964bbb56bf0f0c23bff1148ff6be24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d949010f3da13135e25747e05d93f28d289a7938f18dc2850cf79898e6598c"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb38538ff34d7d89599bd3f74a38fb75ed218057cc09a290704fb433101cb82"
    sha256 cellar: :any_skip_relocation, monterey:       "e8c24cd28708a0651a60fabc3d691ab7bf48c7d54dcfb2cba62e847558bc4cac"
    sha256 cellar: :any_skip_relocation, big_sur:        "069b1e0cb79c36bf959192b8c9416f3ab1754738bb0f3db0b081895766892b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891512cec332ca3174110a283c69887e67a6c0966f6a47fe29a82558e2ae3971"
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
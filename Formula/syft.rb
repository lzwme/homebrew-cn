class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.86.1",
      revision: "e2f7befbfbf88053dfb2007c6499a4bb2d232c3c"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "182ee5818f15313a16ce5366b830ab5fb9c9127c09facf29d8cefe02edd913c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a87804c23f8727da82b43bd155c81c0f0bdeca404db55035906c99fe0cddaf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6e42c365438c6f2462b08338c1a3a50d1e52e1d87b63a92a0fc259e3c2e96fe"
    sha256 cellar: :any_skip_relocation, ventura:        "f703758d529f33c02af455e1ce36d76119d84c9cc4d99f24e1871ee4e100b8d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d4032ed50f52de3d0f905f99f15087691434d659b9787a144ad831de01716a30"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcc679ac8f165d3ec76dd6a84645d7c7678634847e76db973e5a6e75748fa7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f416faae6dacc52607f7e0f369345b8ad0efa1e6410c6b6fce385a18daf57d1a"
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
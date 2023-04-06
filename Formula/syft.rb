class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.76.1",
      revision: "7845381331e873f65fd5013f44b7d85168ced5f5"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4301d14b88f45798d85e9fc900ba9edf2eceaba3173e7d07e49635ec2e7969a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b149135f6a52715bc069a4a844b34cb52536a09ff2cd9bcbde593f09502b0c6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1887e4968bb7acff82b9613e4c620052ee84d361f46e3cc32e4cb4e523165a7e"
    sha256 cellar: :any_skip_relocation, ventura:        "59dcef9e1fb27554ddcb554dc354a627a5774e05656de18f66aec71004abf8be"
    sha256 cellar: :any_skip_relocation, monterey:       "baf72b6d22559f4a035f8eefd43573cfeb96efc0d77b6d416dfeea9121f69105"
    sha256 cellar: :any_skip_relocation, big_sur:        "906223db8dc9f1304d69bb97e5c75faa424b1fe6a36c77fdb60359877385be8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7c20303355132109d578c8ab282e083a0fcf802f4cb9a0fadbc12d5bd1a0e8"
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
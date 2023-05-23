class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.81.0",
      revision: "334a775cb9cd6bf50033de1bb3aa04f46b669f5d"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed5d0c72a098c899026455edd9bf14c4a7231a628462c9741b45cda4cd0b3f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2ff4cc4be29437dad96ee28876a6e4e0356eb16eebb214b56613b2df3aa64c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd15ffc0f0695c90f916757d3e6c02899064d8099189ff71a69c4643fa3ae09f"
    sha256 cellar: :any_skip_relocation, ventura:        "87934215b7d65b91f68c2e34a469fadcbe40ee7245c8c4a3bfc44ed24cd48e61"
    sha256 cellar: :any_skip_relocation, monterey:       "374f2ac0e734d5b33260ceac92a82b5db9f90c2a67c855293d2b17a7e773101b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc155feb4c876dd0e36555a0d4f1afab7b29896cdb00ec5137d89a6e77b3160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67d90043c645a56141632729b298274cb35e998eb998caf420ba54d2844dc2a"
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
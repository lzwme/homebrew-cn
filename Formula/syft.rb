class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.74.0",
      revision: "5f90d0371873faf5eb8f2e748909b32294be6263"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78febedd068e3b1f0ba483f243ddb81784ebf11989e428c65ff97f22a87c8dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ec887a5620173200a7a0a3adb8b8ec61578145aa2179e71fc6bc6d5a1971688"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ccca28cbb3f75d53f748891f3b984faff882df4cde488100c36cc2b022807c2"
    sha256 cellar: :any_skip_relocation, ventura:        "f9d36f4d9b610dd84df414de7ba943af999d917822b53ef4640d71290e1562cd"
    sha256 cellar: :any_skip_relocation, monterey:       "74542e9c49fbc682d2ecd43ee1587305a96da7e3b88d6237896744a813b37475"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2db039f5d01281b01f62a987f34fcbc972c3768deca7631940ab22aa3f7165b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d0d8682891f1caac4d7bca536d260ce858527fc2e0de8152415b848792d375"
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
class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.86.0",
      revision: "f14742b3f3a6f8cd4bc696dbafee53ab1d665da7"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "853f7202219023964b33646650a83926538f1252e6eabafee9752bf75b170187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df88566cf66e792ac37477c5851a73aa66a962a90cfc93d17bf616d96aee44b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dfb691f4402aa16603e690c8d670cf4b08b13f0c8627358569b3f4325462f45"
    sha256 cellar: :any_skip_relocation, ventura:        "39ecbd3d1c4e72ef0f07d9b18c4d7c98ddd2cf83344a90722db792f52c4441ed"
    sha256 cellar: :any_skip_relocation, monterey:       "953cb136651f8b272a3ef6137e77b379762806ac891d901b141237a30001b7bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2258af1077ed0e0fb283459c0b25d8a58af63dc2700dadc3835395ad33915602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d951185191a5ce8aec759d5f4b459396193f09de978138f1dfd54117acce5892"
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
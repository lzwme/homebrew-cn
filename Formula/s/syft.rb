class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.42.2.tar.gz"
  sha256 "355dc28dd7de6a42226a4664372230994c730f69dbb5a3e76d3b9bd943cc7c37"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "323098bae184e3fef82b13ce8c209953baa0c5f2d0560a8329a1228d91f2b46a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc777af52fb13b277acebac52a09a94e897fd25fd5bc788e0c4fec128dfe1717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b555cc88178a11b5840d81f8869836de7ee1bc4d6618281282db093026ae901"
    sha256 cellar: :any_skip_relocation, sonoma:        "185e056bd290a2ccd4ff984a537291746053916ffef51877cba860a727c3a738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1646afb55e1da1ab99aa65723d59b16575d2c853cb8def8240f7f4aacfc64659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ef06dae2957e8728e6a2daec87b36401a4fd952929515d77c08d7ab33a750e"
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

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
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
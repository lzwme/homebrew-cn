class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "ed946fd7a485573e5e7784bb5691d60a9cffffebd330e3e2b487afbf11d30102"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aea5b4dcfada9b2d1c3276cb25fbf0560c8a2dc0441e4c2be29bcff814211f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb4f6ecccb92e3b092ab02c511c1962dd13a26e4fda2ef6fd337be33ba587f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d312f53772c91b245223cf4c6352edd18d2066d5788b266d7f7c1e50d7b6068d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d3368b4ee030816bf177979160b4ab142c0979000bfb0eab0cfc4b2d7d98267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "984561de00d29e84e61353c598aaed485c9c97e85493f0a6787beba2198c2d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76f1f244242750e2f467c1faff0076920f62cf0beabce25342f53784196863f"
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
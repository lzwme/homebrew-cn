class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "d67013800bd0964728384c4450576915bca5758b5c7335e62f22f3f4e399fe90"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eba2c74a012390c1959c142d5f0e005df198109ad9e30ac8814623b201db78fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18ea1d52928d008ab627f4b3dab97ad08459e64c5836faa5a7dcba38eccb100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f81a5520fad15375e289c31a7fa93d41d820a619c5ad83c18f030585994f968"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd08e4ca4a9b769392abbd9c68be0dec6758eb87500738dee0c538fe3987e68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011267b2093cd9197e2f2845e86a9880e035869b4b7fa354f264fa33e75327c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a9b5d0d9b861ff872d7575b9a74c7deb3b0aa5629080d3dc047d54a5575f32"
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
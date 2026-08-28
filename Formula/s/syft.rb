class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "da8d83cdca78f2c553e08a5ecb9734016a05adb904168531f582bebfbb9bb2cf"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "953c3f99e76db3f63362fd035cf428ff75173ea858e86e321dd5eefacb210e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbb1efdf4e878ae660528329c1c7b280d77ffb172a728b628b3dcb5658b442d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea350664ee8dc144de92ac4fdb07df0aa6c0bc97b18bac7bb738bf0be6d74316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc10911dd732fde0c952dd1d32b9abfdb451021fbe023427991f51dca430be63"
    sha256 cellar: :any,                 x86_64_linux:  "d234ac2d2401ddf8fff2befb4d2e36651cf630bd8f5f0c56b23f030a6bed1546"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
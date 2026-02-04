class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.41.2.tar.gz"
  sha256 "29377f383cc262113188bdd373899e7c7f7aa73cb5c5cca81fdf2ee0658c603f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "488aede336424ee79a3134f5a6efd3f2060179b90448430ce35fc75919bba919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3013425ce0540c1767ffec5b986ad9239c4522e6db78283f98f471e9e6a688dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0abf72eaadc7a1a50ab6563faeaf981b838be657472296c96622fb51403ed55"
    sha256 cellar: :any_skip_relocation, sonoma:        "a278833c2226157d1950633368e0fc08b0e87ef378173cc480e393bc4525cf9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d1aaeac0468c828eaaec25f35a2c0298d6c2389b76222bcb831845b7af827c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef9ec02c6a697553ee3d1dcde48215c1a62d8bcf1816c6508905c20e9000660"
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
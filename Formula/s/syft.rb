class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "ee757ade3c9804fde1bdd76474c720d0bb96029df310b12e45d8551545592aa0"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f01a2d53b0a130cd8b949e196b075f416a75562dca2417a1f56b960fa23f3496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58a871fdb19c3574eee8e7cd4a5f026e70c9bc073c7b8a78e6310f07e48b0f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03f974bc1a2a0472b95d7b710f76cd25174e86b947bcd0f0f7ae16f079432109"
    sha256 cellar: :any_skip_relocation, sonoma:        "8184e9c5d0fe14a6951694cc2974603b1af06c6805a4e589280adccca1cdb395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4df4339ed0977283468b1bcd18a971da640ed8b9f09c32b72684c7ea76ea13b1"
    sha256 cellar: :any,                 x86_64_linux:  "9f30c5b9b65eeb2507ce93a751a97d42ed8018d84382a860160f805d584f363b"
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
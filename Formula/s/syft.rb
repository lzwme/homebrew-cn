class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "dedd79d1739833b31cf18b5b082dbf58fd62ebe7dd36b465fed95d6bc9987268"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3c3eb237c5b9a6c31374c418a67541de9659b973ffb27bb136acfcf4bcc9149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa5a9886ecb847bd989bcd0cd843e13451fd9712082e261abfbd944c4e4de739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814622358cf5f8e7828695dda1e0bdbcd2892f794b5a98a65c65c5e6968a3912"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d062e730fb93465f87b85f80b597ccc2cf2ffc070a42a11ef0aff0987143d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d16d12774fe703e10dd1284e4e40b03d5bff10e62cfcd3d118349e60bf0b93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f0be8f698a21fea8240842aa7efd13a6c9e8f0cdf065d6b18c9d8c218fdadb"
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
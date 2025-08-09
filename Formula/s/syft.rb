class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "6b7c4cd5e084b6ca17dba633cc1bb966c9ebfa8a50e95da0ea296c47d1454e50"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "997a4da8c3cfd93df29508e11b5c97b4144604aa9646b95261ec2556edea2c60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfffcca5135f725f7617a1ed6832f3122214fd57ce01f7c84f6c413c02486534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feb8df1ae52cf8521e9f980c124488606a859e14d7421080da482944064ada6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e5599c506e8055a220c1c1aa7928ea6d04cedae8cb36ac3fa34254c2dd387d3"
    sha256 cellar: :any_skip_relocation, ventura:       "7b065af00702f55bdfad982ff982e75ba254a7970bb6910a88100eb88de4fbcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3422bb25b0b0da75b836844c73ad5154a9e695ccc87331661e8b04fafe6ec050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e65569e91d186e73b81bdd520f6cab572d30c663674d76a72da4f2ef225d753"
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

    generate_completions_from_executable(bin/"syft", "completion")
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
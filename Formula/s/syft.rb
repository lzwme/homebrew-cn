class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "1675952c61577db9c5435a8d8b830afe51a38dd35fe7360a8f5c39142908c906"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc2769e843b98dfe46a57e7693a3e1ed17c2e995cfea467119b6522827239f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd33fd209933c9e40337b536833fb4d9ddc1ba42c1d2655b1de2e2f971a26f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5ccb2adbc065f73b729ac0a1979cb167e80d3ab783b4d4319045d503751d60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe33388a7df18cf37ebcbad6f29bd8b1fec6a79b1b67f2a4655a81486f2cd12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3db0d03c72d0e57c93fcc8dfe44e033b485b38d5d3e5c45c1166722e31bcc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6fa00317e65d463f6a3a84360114095cf94b3d9aa1ddb19fd0be62ee99b73b"
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
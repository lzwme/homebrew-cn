class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "5a6969b5e7b172d09049fc728e8e3b99371941bfb9bde4a7c88af1590841a17f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b44f48007aae6529e2ba9f4e80c64190c5781970f24ad8f10ec84ac588aaf71d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af1cae25360c496627a49a90062c631195f05938c9f287218a9a11bec167e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9710b4dbbc65a7e30fe610d393da6adbf74fabfac7ff337bad69cb3f8bf4d1a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e974fd9623d952bf72a338dec00787d85f8f2e33f34d1218bafd4e6fc6be1d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89496ce1a7ad80bf87a9fc03fc90ece9dbe922a9a9ba5840281f26ffbe861525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb428b4806b3fd2d5fcae648fb332cdfce86c1e0328350172d25af02f4613e38"
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
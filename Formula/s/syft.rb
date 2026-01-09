class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "c43a75055ccc0bebc0e295653a884b57bbab2d14057eb9da2f58a83725a10f16"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b69907286ac29af7539689f807b84a8007e949b29b78f187ea9aadfcf7f09c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4983a7c0c5b1fa0fdcf9151eaddf90670fed08e829f9989be000796ca703ae0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4903724c63c4f9daa5c86c6b240ef63ec69a37342a7b115194aeee7fe933c0c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d42774399e2b2cc467abb29850e968a63bf5daee794dfb4419f1f5e4087ba94a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b954b82aa93adf72da42aee2c20d78848efcd506a5d58ecbc4832de5b455bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f551ecb778088c643ad5eefe9ebb5a6102ec11e54a0e068670e1c211b23e68d"
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
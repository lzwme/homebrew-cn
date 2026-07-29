class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "83a6c11669094a6514a620976f22d0a4006509b4e2925f53e43e7bf506f0a3ac"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba9083262718746fdc61c87ce8bc7b3f3e39f54f7dcba0f0dfaef5b4b3499b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6828db98c90eb35866b353cad8f8fa765c930395da83c4569dab42dae80df27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c631c50f6d4f463ec6cd0d2cf9da385b5ce4b3836de34250574d817f87be5f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0f7b593dfe70b37017041ddf982ad27a9594cba3b348d3c68599e30fc9b4c9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7395a5762dcce8ee83e692c3ae531e568c7965d4bfa0b5f841c937d9c34751c"
    sha256 cellar: :any,                 x86_64_linux:  "5894bf10bd1ab440b065274e579e1067cb6783eeba0cc90cc4f5fb031b2163aa"
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
class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "b228dfb35ee9b366db38e637a901f2bf02b704c63c65ea5cfc1047c329edba71"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68fbb9987cdc6360667c601194c7541fa31e197b0936645e32469399437aa8ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d67547e3097357c5929c69eaab128929845cd6a2106d96f877f447879607854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19767622e749b393751806b55c57fa02b7015c0d024623767d546c0bc69d2cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "424a7024db0c1e1df77209e2b04de0dd3e842d401369c1587270dc0683aa5d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "547ceb0331ef333802eef3e1e0751887dd310332ee1e0af66fc153c34ffa97a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc487f68cb1ce548805d2fa399f0c0d46867416f67ac38d8975598412b10f45"
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
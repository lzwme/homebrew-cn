class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.88.0.tar.gz"
  sha256 "37b2c4a3ba555351ffe164293d6f2fdaebf2dbeab69f6ffe8e18b85d4dcebc9e"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca8012878376039205d3c462205992507ee8d38be6d372411a6180d9e4406e84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b8dcdf38ce3a8b008084ab111c7d76b37e51896a854f9e17b3810e888321406"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20ef53a44293aa2557074745d19108b496680d1a5a26c4a9cb35839f01907077"
    sha256 cellar: :any_skip_relocation, ventura:        "1acd79d946885861c2a4489232200299aab9a7dc4cc17d66b3fcd816ba811bde"
    sha256 cellar: :any_skip_relocation, monterey:       "4ce773547a6cdcfb26ef180b993a8399debd2f6a203ccf62eb66c21e7ff501e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "84f3a517b5c8ace514582f0f5b9631f19b040da61d620479883391cd231db3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2365977ac4d0de3b9d39d3177ffd17f27434f2d0d34589ea51c667515c80ca9d"
  end

  depends_on "go" => :build

  # patch to build with go1.21, upstream PR, https://github.com/anchore/syft/pull/2067
  patch do
    url "https://github.com/anchore/syft/commit/aef33a0effe14830347867f24ab18aaac2d679a8.patch?full_index=1"
    sha256 "c78f11977678e324b550dddd0e1b3a18051cc015c4156792c72553b3c6ff14d0"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{tap.user}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
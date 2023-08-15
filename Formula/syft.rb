class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.87.0",
      revision: "b3d7ba569b64376cf33df717e3bc40d8375e033b"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb029d6003247c1283e642d4f2da0ce270150238e7ffffdeaa7cfcc563662308"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5236d0759c89722b766198dba2a3b619c54329f46741f2aedf3b4c1260c62d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f8c4d6df231d8d8d108cec5f05864c05097f40892dbb4bbf0c46444c8a93d99"
    sha256 cellar: :any_skip_relocation, ventura:        "86317ad0ed34c5d7847e02639bb01998580ca043148562f213399ec62feda3ef"
    sha256 cellar: :any_skip_relocation, monterey:       "905e9da9425d4f9428c16379f49284f015c7aaae70bd5c0c1b4a2af1f5954d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47c0b978da21fc7f8ff29dc2f1f4276987f4266020e50d2f434ecebf898c34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab5d1b5d4b51bbf6f9e2b87ad4e55a286b9f3bde4e938440b97180ff874e338"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
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
    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
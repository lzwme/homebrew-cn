class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.84.1",
      revision: "791d1f955215f1dad383c9835e4d3c01267dc0f5"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c93b3f7679e9bc471f4d6ed4ac01d8e65e4ab8057d240dc2bd31519e3125e6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65943ce4c085906d55285f2db9ac965420a5250692b226f65389a8d6aeb2c5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d0d7bbfe5489f420f28df8aba3373d0eee585a7aac338699f3f0cbb2e911deb"
    sha256 cellar: :any_skip_relocation, ventura:        "187b1ba0e35d4d8f3715fc2f357d43d012fd213e0a9308f7fd15eaf11290088c"
    sha256 cellar: :any_skip_relocation, monterey:       "bdb1280c2cedbc742df741a8501aece66496b7bdd9fce77adee13ab6b36bb224"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e19340805f29e7112cd1b120c74651016c739fa979f1846c30a72f41fc55d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd7acf96971b7c0a7746b694c58cb246521adafa5fa1757418fbc2a1fc17cc3"
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
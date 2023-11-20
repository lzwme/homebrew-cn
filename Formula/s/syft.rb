class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.97.1.tar.gz"
  sha256 "e9ef89f7497d7d4cddee0d1ad0fc193e081e911eafed494f9ab2c5995f777bd4"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "373e3185ffefbc77a0814bc34270faf43b7524c151cb23608ec5126cf34b62b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afabf518af5cd56afa28fb57427a88bfe6a63411154f7fa5112b03b88de5e6e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "626015c38b08ff5d6e1bc53e0f9b2539d692151e31c001a6777e3acaad0ed9de"
    sha256 cellar: :any_skip_relocation, sonoma:         "42f6f5091b3b063767513677d3691841afbb06d653b58867c75c23e4beb8fddb"
    sha256 cellar: :any_skip_relocation, ventura:        "f8a6f0b67ec3595ef432abdcb38c4ded912126dcc083ef0002cbf30d7d05d44f"
    sha256 cellar: :any_skip_relocation, monterey:       "4898b43a9ff6ef755169d4d170d0e1d3589e1b8d079f2e33e451c04da0cceb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f78d78191fa550cdffb320467fbab3f5b59e53c14c54f2bd5b4079381aa8354"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

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
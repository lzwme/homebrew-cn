class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "693090f78f2684d68fe8cf257392aa9d442c43193c23813153798ecc0351f6ba"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d5ef13519153d87d02f745f4ed521b17ef357187dd47b9422fd10f39e98e7e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4813e71f027d2dde1ff0ecbb5740763eadd2f1df2d196e1bebabe54b28658d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4157fff0f8db3e440176443fd069363e2eeae9355560e3529d08525bcf9cd72f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2c15153a64e155bc9c2a1a6d5a911092d252ebb7e190bca647bc1a622f09d5"
    sha256 cellar: :any_skip_relocation, ventura:       "ae476fca5e5078458e0c6ac457a4d86ad2689ac489b3691ee26f03305c7b4b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3afc1902383b0d194ecc5349f4a161dfbdda0f26c938da24412eab5d9c513487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cac3a0fdbbaae4d6c01ac07fca0db839e467f866398ea55ff6a781763a37b62c"
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
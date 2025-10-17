class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "92b83e80041931ceb54af0283d9a09b4bb7474578c33903db20a8394b791ba3a"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba567653f6e31db18a46a2aae084b163aec782231fbbaabdc27229858a49bbeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cab9414d6e05302a3fe3c503468a622178623f195f61fac54ae3d68a1ced0fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291877aee6ba132a686c426b774f43f34dc34ac9334019f98e147ca6719a7b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f9fb974e8751e79f609cd4694d85dcfa274e12118efb26a882c450f07cdda64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b13459e7fe5586688417f75fcc1779b12d01682ff3830623cd2eadfd9ea5df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "910ce1c74b403c1929fae09017c544b0e98798b3d3c788622556277f1f2dcf75"
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
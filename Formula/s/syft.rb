class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "bcc7ef841cf0671c46b9c10cb13466a833a5a1dc010c68cc5e3658151c758c2d"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2ccc71e78559f316d6c922039e050bf91d97cfe57d097bab45c44290ea2a932"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae238e5acd5a9ab0d3a064d07b597a9e854faec945a211f6bcb7971ea3d0ba0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "389cc6542869c0e1bad8b82a211b4999f731a96a2795633f4eca2b520fd74ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "008576d46609f4b0a70123bdc5ea366ebb2ec64181cbf74517bfe291807ebded"
    sha256 cellar: :any,                 x86_64_linux:      "f3c1ab3df364a995471fbccc228c9d9b5110c834f1c2f432ff8bd0de169dcf38"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
    # Redirect stderr so the progress UI does not engage on the sandbox PTY and hang
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json 2>/dev/null")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end
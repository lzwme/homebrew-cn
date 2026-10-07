class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.54.1.tar.gz"
  sha256 "e3a8b41ef4050665edb7cb35bea1ffe49ab7bbdd3127e756ea7cf979d41e9dd5"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1d3611ad1e109b56a6567ac35adfb5031accce6498112ce30d81033cc038e53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75d9c0addcf67bb2ddc8bb95c2d76d67158726a64b92ac3d93d8b8ee074c90ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26cb5fb5d60df153eb35a31342e0d3d1efb612f8fef4fc6b2d13f73e72d1a208"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d32820d93a4dc84323bd951aa16dab600d42ea534a252cd7fbb230a329cbe2c"
    sha256 cellar: :any,                 x86_64_linux:      "ed11cbba2f7be4376a7cec82cab4c105c11c6f8fb3b4ae162235eaccefb5b388"
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
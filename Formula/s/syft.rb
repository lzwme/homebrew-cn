class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "399e8b4bd1a772212f5e473a480a571bef3e7d2f55bd489cb3e6932dc62e341c"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4ed1f8abf47ede3500ea742f9d27cd443f57b22d660a8d83fa93e44387c1a6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cb2f006048d49b0cb94138b096b974d041d47193afa99b575719dccde6d381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59ff696b896e0e275912c870bb103f591ebfc9c916a1d7348842a7c19a79326b"
    sha256 cellar: :any_skip_relocation, sonoma:        "11dc6e674fc9658c75a4fa24a6cbb5b06564ef84b02de783600672879913874b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf7c43c87266a314d2ed7cdd61e26d392b7fe340e025c1abe9e7e62237fbd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb2d5db72932ec61f3afc73c6796bb9880028d1827d977dba6f00670feb8ddcf"
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
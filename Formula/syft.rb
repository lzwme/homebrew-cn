class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.85.0",
      revision: "4fc17edd146af34ab06f5b0443ef8ddac3aaf076"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27cdd71d527e3d63482a8cb596cb461ed13c3d91ad2ff7def37e74534da60da0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6386fc5f518d8ec96eee0694e870d6499525db6881343da8f8d5ab0ca1f671e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e232a139d183565c2d0a6e9e1bb66f97678fa9f6ba76be14ff66de5f0401db4"
    sha256 cellar: :any_skip_relocation, ventura:        "e3e72590bdb60d47eccf8e7906390da550f46a111edcc81282a8a29a9533aebf"
    sha256 cellar: :any_skip_relocation, monterey:       "e937105cb7a3bea0a13281bb7d72bdce9cef967a8d6c5c92725f66a26a47e75d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5e6d93ef1a8c896e087312d9d44a85b0d116060ac086126e8580297d5b7bda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d014cbbed54b74cf6640740ef37c5cc09051b9515bc8acb84385b15acb80b9"
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
class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.90.0.tar.gz"
  sha256 "50b5e499948d06905e4e188d4189d4520aa0e28d7470c9a459a12b26af28caf9"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bea3c1ebc5a565cb995c9384cdba3ca5d75d49257591c705230dba538c9c2520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d225709c7c3fa89bf94e71080e6fc1e5f9f29764eed307f991459af53b8937c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee279d6e18305154b02136ab0bc4ed01914736f907a9584eff171c1cfd7d8e4"
    sha256 cellar: :any_skip_relocation, ventura:        "f7cd6f1b43a287c091f433f6e7bfb37d3e4aa547b9771f258c8a1c8b568fe9d2"
    sha256 cellar: :any_skip_relocation, monterey:       "cf444acf1c3d61463b8108c318c37f7ce1e6981e54a21b234b8a8cdd3c642d3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2848bdf25a32a67d85c50107bb87d98d864f0f0969bf52e5fd7ed861b7a9d88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224ea4c1e20a1cced153b71d2f872bcf7feb64d5396fd7669701db55bd2b79e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
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
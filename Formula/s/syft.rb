class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "11962d7df9c5f2a6a8dc2839ff5651f4d9a69be90862fec4d0b947f6378ee5cf"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3154df7f3e02cc1bd0aa5eb6286bd521f3d6d2ef30821b8f1145ec4da920c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ec5b4319b03fbd9afba6ddbe06b73deb5d5184a16649c4271b3c74b28923267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b30108fa861413f7c8b51970d1cdaa4b0707e5e20333fbe941612d8760ef8c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6baa4558147432059a988719180d411b97fca9327b6803cd1eb818d2ebceb47"
    sha256 cellar: :any_skip_relocation, ventura:        "225797c56221e0c72ba56148f2d4b58f5196effecc338f468f52f3af61fb1a9f"
    sha256 cellar: :any_skip_relocation, monterey:       "b5d7cab3f86356e77c38921882c2de3c74ee66fa413a609e6f66a0c08a5c8e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1c35bd8627a10fa6e02d47b809f7e0d40cfc2084cf5479498c0eca012551a39"
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
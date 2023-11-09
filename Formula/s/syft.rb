class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.95.0.tar.gz"
    sha256 "bdf4866ee53ac0209b0b8768a147e9c79bfcc6e1c788a421f84ede8a7aa4f7bc"

    # fix `identify cyclone-json without $schema` issue
    patch do
      url "https://github.com/anchore/syft/commit/d91c2dd84211d825012063f78793787e7cbf2078.patch?full_index=1"
      sha256 "51abff0cf89bdf75dfea1ddcfce9d7d28c919cdf76a3d83bcb756b4b3c951f14"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04e8ed24c3bfd89e72c686958851831ca97ddd168a7e1555bc7fd4369c44033a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23b970dc68af24130c4163fed61a3ad336b2dad4fb710a6b43c4fdef5ce969d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1d90c6cba241788164b67d6ab015a1c66aafd255649c48cfaa989e23e43b78"
    sha256 cellar: :any_skip_relocation, sonoma:         "f94abea9804e260157c5c5f3ee0ae4587116fd34f7dc6602935fad9a8067ba53"
    sha256 cellar: :any_skip_relocation, ventura:        "b10d8ff6de5bfb2d46a52fdbd72dc359a2d61382a6ff7dd8dda8ada430779a18"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe44abd5b3dd8b18aba40854f8071de564d99b5ffbe3454766d47bee84e7859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83c116040742ef6f077c9598af8e22515ef41b743e9914600ef370371cd4524"
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
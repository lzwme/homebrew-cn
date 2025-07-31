class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghfast.top/https://github.com/anchore/syft/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "a84d4cfbe2ec9c551e6ca68fbbc8889b2fa796e6b71936bee621fb0b654656dd"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554e90a7db017e885588752ba3ffe7ced4d649e3190ae62411602c46d863287a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1978004e6f20a46849eaf1775f1e0031aa7037937deae9be2889e140d56b9f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c733ca47528cd4fc890da21c23efb9eb398d7322a740d6f683e35dbf355ff69e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ac4ce5178315fda15ccb4fa6509e21e8e9add8708731e212c74bb1edda72fd9"
    sha256 cellar: :any_skip_relocation, ventura:       "d7ea1c00ec8f0b1e3b28393e41a9684a5b55c9816253feb24dd3e11a89b03979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f6e8d74aec3bdac11255dcd1b622af79d6919bc5c83dcd24ab08373ba45a379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f8ba9e24853672467449d360085ffec5360a757c52ece2255cb7e56c6f6646"
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
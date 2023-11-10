class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://ghproxy.com/https://github.com/anchore/syft/archive/refs/tags/v0.96.0.tar.gz"
  sha256 "fb8c003b5b11bbacc66dbd2e60f1ba91a8d96cc91653d677fe9b460de912fb21"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef7e1056c3fb52af6298418e368aaca4e0eae9855e2f7d16824335f7b60411d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29246295557056fda897ca57bb89c013faaa29ac32558cde9206e70dff47355f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2aa135027640e49907109fe6b2216bb429a08c4a06f9be5a9fa03d05b05c8c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "79d6a5d8170cd6d8e5a9b9964fc11c859613d6ef0a453b41a8f3900b516307f7"
    sha256 cellar: :any_skip_relocation, ventura:        "9c5aff5e1c7fa7cfef8d4261ee9c499fa87ba401206656474cfcc44d678c2c7d"
    sha256 cellar: :any_skip_relocation, monterey:       "8bbdd87c0ccf18d185586a4e3e2ee6963705a0f37fb5f277324a9bffe114756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e7febf2e4c8244a885515c51340549e2ee265b22d82c087bf77c024ee61913"
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
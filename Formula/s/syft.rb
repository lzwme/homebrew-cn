class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.104.0.tar.gz"
  sha256 "58a1389cff3d3adb7adeddf3e6d733ab1337bce12cbc59e0e68ca434ee9cda31"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198eaf197b44207e5528ce1acc135df4e749570812a132273312d4d335f12e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43f01b59a989c945baa5d413b59eab89c5bca2ee4ff9d3d1e72300c6d6ade0c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576ee156c835bfc9c9ccebd25523a7d2a47e74b65816023c20020a29d8ce1b86"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f5e317507e424b93c34192c35fe338e969df5bf2494ae4776ea56d8054e0007"
    sha256 cellar: :any_skip_relocation, ventura:        "ca408d5a531561776209e933c8e46ef23fb84f8c8d0d9181c79e1961df67337c"
    sha256 cellar: :any_skip_relocation, monterey:       "7073227971f2e547a3e7c642c0500909cfa64ad67e816d75428db05587c9ed71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad017817be51ba7717f1503bbdf7a8ec92e2e1dc92adfee88b5a662df60766c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdsyft"

    generate_completions_from_executable(bin"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https:raw.githubusercontent.comanchoresyft934644232ab115b2518acdb5d240ae31aaf55989syftpkgcatalogerjavatest-fixturesgraalvm-sbommicronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}syft convert #{testpath}micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}syft --version")
  end
end
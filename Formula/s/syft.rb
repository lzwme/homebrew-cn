class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.14.2.tar.gz"
  sha256 "555b084c974ce6bae3beec61dd7f9a5a9adc4552d99b26aba2671887913e38af"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2343c5239203a9cf5b8c0665f8171280dde2ac6dba5ffae004f5da487c04488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e917b9ac31ea8bf1cd6ca6e2825aa34e27aab051f67360868498db05680ba9f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12b81793b4d2dded17911d8f0fc4c75eb26d0387bc138e2b76bcae037bf888cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "36326df3069736e8b79fa722c30dee1e267caea8fd5029d9936fb1f969b8e637"
    sha256 cellar: :any_skip_relocation, ventura:       "c512b1aeace615d6ecd120147290ccd1b3bbefb323c2eb7f8c747deb8ab9b912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6c5d0090c3674bbe7ae7f6975c7ceb2ab990fbe1fa481f3e1816795ea0af6d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdsyft"

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
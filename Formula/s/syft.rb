class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.23.0.tar.gz"
  sha256 "dacd52e9680082a79a76853fd3f9d6722e83134e5e35fb8e72e8209f4574e8a9"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b610926e87e43af60e946a0d77607c5c86e68e6f787e270acd05af2b7189218d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80d33e119d801e35a21b02bd03e9fbecd20319ce6b62132d11d961449a5e259"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "920cb51fe3ad4e77a251140ea8186ea1685eb77a589114c2894f6d63b46403e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeb1cc0322cd18abe4a3e6b107ff3289fdbce21deabc34a839207f9c5766062e"
    sha256 cellar: :any_skip_relocation, ventura:       "ae636aa8262fb5301dc261218b15e7112fd639e739e5a43ee7b3b5854c75d12a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b623695f952249bfc5bc60b38a7a485a474cf6e44585e83f9525307c5eaa69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3862379ab25a2edebb406d2cb51c9cab7bac3a1fc4117161c114606ae3d2289b"
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
class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.17.0.tar.gz"
  sha256 "904d3a64b750ef142b325670a55a7e8a9c4dd913998a752497ccc2c801ad6192"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e226a61dec868fb6b6adda905ae758770077e78847eba8412f32c85966f19d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32da17325634e626dd461c4f6296f54ffc890c18c0b88ef5a8a3eb412f34287c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb4fa2a328afd9307c6e34b06c6af8d68653a25e51b0c742f3828d524fa34192"
    sha256 cellar: :any_skip_relocation, sonoma:        "63cf15eef3e4435219a3cd9ee38792785eb7208f0d4a185ab52f858965c87215"
    sha256 cellar: :any_skip_relocation, ventura:       "63f37be8a733e6cae86e570ef90eec957edf70338bbb89fbca5f683ecbd0547f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6441593690e938a530a997331124777009dd6643062bc6b0898f4af2f17ba7"
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
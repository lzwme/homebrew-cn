class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.10.0.tar.gz"
  sha256 "9b643ba8bcf01f323d8ef35d442bdbb0d463efc361760a1273bd146e0a9e0d1a"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba87a0fb3f0d3960b7b0992e84c0f980c9b6ea1c22154873432a19e1c0356bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33fc3d694297c5264b87819e8a5fd6686abe588cb297504343908d4ca0be0400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207fa891fd1bf921cf749716e25f2a3f72a44e36ea87cba3136209a7858a12eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e4198ed01a4dc0ec645d7b16bdd6653c3f8f7e580b35b13f7b45424c7b0548a"
    sha256 cellar: :any_skip_relocation, ventura:        "df320f59676fd7b1d32e1d7ec892482f6a3b67f51fde1d60c43be879eafc7c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6e08cf6eadea3ec7d5215e52a3c42227faf550efe3eb5361d79244ec4923cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c19ef04cc78887c7cabe34c2aecb6a7c8b4f9d4f8e33274522f0f6d3b090757"
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
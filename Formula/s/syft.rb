class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.11.1.tar.gz"
  sha256 "2a998bc29b5a8a232056e5ea8bbdb2e17289732cbff119db50cac61c5f5d0def"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55fa6547dbd1d9e3651f01c273982d9ee8be8f7d57ac4809a9faa8b07091687d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1b9e93fa3c2c50b24c5a11faffab300fec2da35ef459760a7c41a260a659312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a642df7aeab4295cc851bb984271533bdb23093385b547698c0c3c9f0a18b9ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a453367efd63dd6b082eef61a58135e039000c9b839506f14d594c3ab2b18c4"
    sha256 cellar: :any_skip_relocation, ventura:        "d47e82aaaf3f3440822aba3f2b41ea8257555154f89a3bdbdbbc81e6a04ac3fc"
    sha256 cellar: :any_skip_relocation, monterey:       "34f457b5fccf78867f7ce72e6263e6db052cf929231a2badaf39f97c8a0a3023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2742ae1207895adbf25f6a46d97675f94daaa9aca6883e8cf3fd6afd396eeb"
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
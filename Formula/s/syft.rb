class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.103.1.tar.gz"
  sha256 "3f8dfd2e8bbea83dead8d5c155004bed9e76f5aa27f01536f7fa3b7aa79de9bf"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "962d0d67e2f90bf6ea5c26d9e78ca3d0bdd23d498b0c19561d2f703c4e841c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28154fad412c877bd712939301ec9788101fcc1a6c8ac14c5afd4c244492070f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07a2c6cb3012ccf7ecaa5c29cf9dc88ff3326ce9f142afa61ef0322a15dfe4ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "5525a2ed41e766c128b40476145f8bbd532a5a4adcbb81a1586bc94fc0d85c6f"
    sha256 cellar: :any_skip_relocation, ventura:        "c74418db97b4f251473aef1b16b330a0fe52f772aa3ef3df3ad1a91813f07473"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf847f35ff575b03e7977978752b600bb2504a348dd474729253741ffa6f09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb42d9609a066a655b6759eb3047fafe0e8e34edab17ddf8361d2b4bb65195b0"
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
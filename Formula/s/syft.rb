class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.21.0.tar.gz"
  sha256 "318b44d6a905695f7041b0d166e26eba41be46590eab306a9239a4e11fa31eeb"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c710bdd436c0cbed23c3858d36b1f234b073145c4fbb0c812966a9dc10c8dc86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c2fcca011c22076cbd684179cae3af8fa12862ff755afa5a0693b72f42804c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a9e88e37ce7325e9b1a7426166a2e8f6f700bf0cd66c8b74269775b7ebd09e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f782dc596d34e7361d2953199a39da0f5f6485d41eab910f69db0ca5a6fb37d"
    sha256 cellar: :any_skip_relocation, ventura:       "89fb9039405ccc983c1d4d7ffbc2079eefc4dee6c51c095a6f52149d0ffb96e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c36b6dbd2b90fa8d4388b1b5fdb33576741f365750ba1518cbb4401c4fcbd3"
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
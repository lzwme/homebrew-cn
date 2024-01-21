class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.101.1.tar.gz"
  sha256 "1d16c9d09a276c597f324b7f57feccce57a885087bcd5f38c0adeb4fa34e52b1"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a107c92c0753e2dc0946ae28cbf422a030ce76cbf1c4730182e5f68865a57df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e60b1b6a20d2b11560c2139658d45a6864bdc16fba6b0d74e2c35ad3a681333"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1743e7d3701d5b33de41f479b573cd2b3dff5f4191b18cf41584e451c4123b89"
    sha256 cellar: :any_skip_relocation, sonoma:         "053cf8dd2b13df170717e576b37d44f06828a92ec1f69ded5ce80ee431a36936"
    sha256 cellar: :any_skip_relocation, ventura:        "3229dabd81395e26d6d0faaf63bb844eeb81adeef880b273117cbdccba0cf1b3"
    sha256 cellar: :any_skip_relocation, monterey:       "4005a290cd8702ff8f40e184b31ea0f05d6e1517733c1e524b72ca477e48c93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b41e7179309fd3863bd5e03ffd36df7f7cb49383bf4200b2f25815facab8b4"
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
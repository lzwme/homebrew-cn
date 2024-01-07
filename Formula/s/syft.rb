class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv0.100.0.tar.gz"
  sha256 "2dec7f010f2d791702e87ed2642f20de93851aab4f98f3a72fb9b1c7902fc235"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d65dd53386cf2fcbde066c94eaec2139194f4421920d1191ec77b0f8d87639a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f746327b52f109ca788208cede85a0467da6ddf9400927ae3567a331d2054c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8d168746387a9866c90391b1eaffeb1b38736315442c53a915ec57d8c2e574c"
    sha256 cellar: :any_skip_relocation, sonoma:         "23abf007a45b312429bcad549ef7d416f93a603c3dc1db3a80bf67c70b5b0d14"
    sha256 cellar: :any_skip_relocation, ventura:        "16f610d58b103ea1e6bde9ea57ab485381eab2ec21e47d8934c60d4e53d9dbb3"
    sha256 cellar: :any_skip_relocation, monterey:       "2558e9727c6bfb94255d23e99fe889646f00afe320435e52463ec8a5162a8a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a362662f99dfaa328f8f65ee3fd14eb6b965303b3bc92998ddf49faf1001d1e6"
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
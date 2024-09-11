class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.12.1.tar.gz"
  sha256 "b9db74e316bcad09ab3161b606cc26f7f0284bf129c17d053ae8c4944fa50409"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfda2f4d23503f992fd32ab73163a68257cc685a2f4a20628c0fcec55e403ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3589313f834a6526ed3d4a4bd708d7b91489998734b2e191f93427e0eb1d486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee1aa9113c54603c008a15996ee5f444de851cea8548602d1ba033cf0d4cb9b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b964cc878690a25cd9f3b784f550bfdfd17b4cf7910207caa438c7d16118d42"
    sha256 cellar: :any_skip_relocation, ventura:        "f746ae4ff2c5786f47cba4018728e4d86e1e9c51c92e0ed09b18233a19ba39ac"
    sha256 cellar: :any_skip_relocation, monterey:       "fe200a092e3dd1d1bd550c67e1f6350132ec1733c94474d34a060bdfa0c23597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574f94ad557037f5a4c12d6c05288bb981f280d33346d9ce3eb6c3215719caec"
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
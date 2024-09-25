class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.13.0.tar.gz"
  sha256 "43fb68562bc731edff8e4e6576081dbe6c7e3e2f02d238e9af3e141ad1909b5e"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c4a71011f238ae507ff1d97a040fc93035b260c1228a62763e7ee4fc4504771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504c41ca0f33fee8bd19b796e10060627074689eef9694425ba0f5865cc43e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a3cbc0a0bf0351b94fee58a4080e98aa42d0b06dbb07d213a17a600db241865"
    sha256 cellar: :any_skip_relocation, sonoma:        "486a8eab82384d60606d12cd8ae2318f87a06531149f25cce29b50701279be70"
    sha256 cellar: :any_skip_relocation, ventura:       "157a15cfad497c94ef10a77202864b377d2d241bdb88225762ca73004204922b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "651276d9b943f9ca420407ae7a22dbd156dc472e6fbeec4359cb8441d6c160cf"
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
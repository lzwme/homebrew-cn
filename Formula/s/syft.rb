class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.20.0.tar.gz"
  sha256 "922deefedc1321f6f74fde7690e9321494a5bef11f4d5c4a6dfe8aa8df70f00c"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbd19b80d83c2e300571b6cf24eb8d836613dfde4c3528a61b42fbe55f260b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8160e3832be4715289bf0341caf7ed61020edf8f76c99a1f812cc4384fe2038"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02389d7b58d6038b5665e7adc42050f964d517a0a246652a1d0d31fb54f8a853"
    sha256 cellar: :any_skip_relocation, sonoma:        "04be740307b95f989da0d61e5aa77e547566c0b48b0bbed456de95c9bd3da2a9"
    sha256 cellar: :any_skip_relocation, ventura:       "72d0458bfba07a54f5ef41ba5303916163ab224646708ea95df52c3a9e052a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82190c60c39ca668b50884baca7855b1241703f85e93f3930bc86412d2633e48"
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
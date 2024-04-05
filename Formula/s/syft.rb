class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.1.1.tar.gz"
  sha256 "965333b5da9310a3982fe930ccd1b3efd23b78c0ba7b4c4659cf9102c591d150"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a14f448340726c35889e3530b20f97895d8c787208056fcc694f6fcfbc4026"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a946891df36f9b9da9c075c62d253bd7e6d40d35539d32b704f324be0d73dcf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d47b2881feffe4361b0b26427d8a2caac372c3142b649ccae4cdd5db2fc8eadb"
    sha256 cellar: :any_skip_relocation, sonoma:         "053c679d24c9f0c922b960ab2a93ef23783f55a33bfa88aad639896756bbe7bb"
    sha256 cellar: :any_skip_relocation, ventura:        "b31c005f0117abf45883a24fbddc905b8fbb8df46036cd7e28cca3343ef53d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "b1617cb257398d7f6b578ad333046bb7598e95e72b0628c4ffcf1fa150963d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76d058a8bff4346b565c1f78962c70c2812199f7a963d492d7ccd422fc64c28"
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
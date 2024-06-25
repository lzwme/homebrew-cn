class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.8.0.tar.gz"
  sha256 "7bcb3a2945a6a9101c10e37ae6922cac78bfdb78c02c193144b772e3eb7d7a87"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc0141dc29f67ce9f1e6eb96770aa987056c88c4dbbc79f387efe390b6981f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dace88ea383feec72ce52db9d17d5264e7520736db45c5794549f3433b0ee418"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe5850fa4aa6433ea302b2cc102b268cc19312825cc14d4d4fa8276c177cc913"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f24349b6d9221b174d3b19faf41b5149d0195f0451b5aa5fce7a495a628143f"
    sha256 cellar: :any_skip_relocation, ventura:        "513dd9bdcd6b91e3a2366e8c15372e20dd64b1949ded0cc1ae54735a75bdb12c"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a74126da719f4fb644123e657d420cd792777c080015ca5b1ef9f4ed043f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13df85ad34db5da2b5d44952bd94ddd6da77a809dd7035c0f28d6ea568cb2de9"
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
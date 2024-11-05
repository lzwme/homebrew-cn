class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https:github.comanchoresyft"
  url "https:github.comanchoresyftarchiverefstagsv1.16.0.tar.gz"
  sha256 "ebf48d31c816a6d1689ed281cf489bf0813bfdaaa91c67dcb40f21447cf15dfe"
  license "Apache-2.0"
  head "https:github.comanchoresyft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ae8be3f0527042f92e2a82be92368f5477fbeb4a51a0a32b3981726dec2e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741845725ae4316982b284b739170d4ede8fb430d75a087ede9962a647f0c96c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1efa9a9965be7666c19e0debd5bbce8bc8c02c186df660ad4831ca96af68db6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8390ac47c0037d47dccfcb27d8fa1c11ccfd22ea882d5e6c2e350a809689a33c"
    sha256 cellar: :any_skip_relocation, ventura:       "3b9a4fad10dc71a1bfcf3121508e91a23006d3e979a6b50a2e014bba3a81c960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1d4aed0f51a425f6cd23a8c02175969950223a8bf9a45c267c44c9ed1b8aa1"
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
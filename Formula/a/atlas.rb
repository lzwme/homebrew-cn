class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.17.0.tar.gz"
  sha256 "b142958afddc57d8c77b36a5950331f2629355760a477a1eed2e9af7b97b0f78"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "136b1929d13f70a619bf4bf1a94a71d8bffdbd387cd18ac06e788ce4591cb0a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03f16715cddf721eb8a4d47e3d43ccdf62d6ab19848cdedf3a4e2cacaed5400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f1bdc2d3509d081f5172e73dce48fcfd873da05a2e52959351f6063c7ea591"
    sha256 cellar: :any_skip_relocation, sonoma:         "4521a0b53204b92eb93db6bb578e8de45858013d87c6173758114302e3045d26"
    sha256 cellar: :any_skip_relocation, ventura:        "87a78b6f8ab28e7e2163055ab8c567bb3f2820ede9941ca81d6b133a53766b21"
    sha256 cellar: :any_skip_relocation, monterey:       "7758b292b2d99d4a29267ba69dc9c0bbb6a091e9efbc0f44b118bee7dcc5d9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b2bf6d592d6c0990b4bd55a0d428cd72dc74550c1c0d6f4877daa8a3aebd59"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end
class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.27.0.tar.gz"
  sha256 "444eed6b081269b9f42839092689ef1e935631c8c5890a53dbacac1ed2596a11"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b6a9ec3cf11eb1dc65322e39df31a08f2d14acaddb737207eae1ebff876c9eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c58de084bfd7fc470691e590758986e085bb8037bc082ff52f005cd5e2bd3d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94a7f705e06e643d658d302a7820ec9a49b488a292e61c5c7e85f8798018360e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f69659dd6b4417d8075105a21930fc456fe9a8572d7a59c18dcbe89055d0da7"
    sha256 cellar: :any_skip_relocation, sonoma:         "23c4d10340ba3412d88f81180cd9064b30e2956f5c5b08d3a1943d68a8bcb32a"
    sha256 cellar: :any_skip_relocation, ventura:        "0f03a3233a78a3ffc7a8ed51feef8c2cbd0065f30dbcb24de49a8b75173a2184"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ac413768e23e4b8ac5e2b59199f685b4a2f1af605d9636af33d70519aee4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e611d691eb041bb1bc8c577a9a83aa39143f15538dee1367fb2cb196ac499ed"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end
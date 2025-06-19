class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.210.tar.gz"
  sha256 "3c567cb9b8a0b54060a3fb704cded98d93dbb20b9ae1bc72c9b261ca6db22533"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05692cdeec6e692cabb101e0e116bb96fd564c171609d818280fc92b343a2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b05692cdeec6e692cabb101e0e116bb96fd564c171609d818280fc92b343a2b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b05692cdeec6e692cabb101e0e116bb96fd564c171609d818280fc92b343a2b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "494122948a4b2e48debcba40c300c399b2768cb657566f791f37371136b931c8"
    sha256 cellar: :any_skip_relocation, ventura:       "494122948a4b2e48debcba40c300c399b2768cb657566f791f37371136b931c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5853f8fcd106ff987e92b02f0504528b5b624d2b48e2ae14ea92ea3061a96339"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
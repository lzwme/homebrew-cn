class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:cadence-lang.org"
  url "https:github.comonflowcadencearchiverefstagsv1.6.2.tar.gz"
  sha256 "2e59b54bc4d9b09c643f50a2e03afc1eae558d2f1bfbc116458d7916cc38271f"
  license "Apache-2.0"
  head "https:github.comonflowcadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7400ca3355d5bcf3952c4d68648c77fbe210b565ae95ca353eb555366caf93dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7400ca3355d5bcf3952c4d68648c77fbe210b565ae95ca353eb555366caf93dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7400ca3355d5bcf3952c4d68648c77fbe210b565ae95ca353eb555366caf93dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "477690c717cf43fc4cc33976ceeabc2591f1e2ba425505e457b90198fe76682b"
    sha256 cellar: :any_skip_relocation, ventura:       "477690c717cf43fc4cc33976ceeabc2591f1e2ba425505e457b90198fe76682b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28d3d7949884424c81e05e67ba645e8cc971442304238c49156da68a4503ac1"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdmain"
  end

  test do
    # from https:cadence-lang.orgdocstutorialhello-world
    (testpath"hello.cdc").write <<~EOS
      access(all) contract HelloWorld {

           Declare a public (access(all)) field of type String.
          
           All fields must be initialized in the initializer.
          access(all) let greeting: String

           The initializer is required if the contract contains any fields.
          init() {
              self.greeting = "Hello, World!"
          }

           Public function that returns our friendly greeting!
          access(all) view fun hello(): String {
              return self.greeting
          }
      }
    EOS
    system bin"cadence", "hello.cdc"
  end
end
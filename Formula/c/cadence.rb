class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:cadence-lang.org"
  url "https:github.comonflowcadencearchiverefstagsv1.2.1.tar.gz"
  sha256 "650969954075e63323d7cfdb5ad4aac5cdf96ba03110117133dc6ad6efd81b1b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620788649bcb56931a3abc072a3dcc88b412dca884e0c8a247d10053e0fd73f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620788649bcb56931a3abc072a3dcc88b412dca884e0c8a247d10053e0fd73f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620788649bcb56931a3abc072a3dcc88b412dca884e0c8a247d10053e0fd73f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a4692236874141ecdf43de812c119e12145271cfde7349bf408b5af7ee85e78"
    sha256 cellar: :any_skip_relocation, ventura:       "0a4692236874141ecdf43de812c119e12145271cfde7349bf408b5af7ee85e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5879690e712f51e7852d38fd68a4e38c7f91adb782b223855578bb2826aeec"
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
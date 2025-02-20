class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:cadence-lang.org"
  url "https:github.comonflowcadencearchiverefstagsv1.3.3.tar.gz"
  sha256 "0b6df2409b8f9cd0e17e370ed015df044bc6d65aea4effc3c7a54f0fdae0fc71"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57913d85b718501c37c68a4ca2994f3868225fbbaaf05df553a60b3ab5d7d748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57913d85b718501c37c68a4ca2994f3868225fbbaaf05df553a60b3ab5d7d748"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57913d85b718501c37c68a4ca2994f3868225fbbaaf05df553a60b3ab5d7d748"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fcdd1ec263df4eb220d3e6a36f74c4e6f433b4b7f971530115925ff4c5b4dbe"
    sha256 cellar: :any_skip_relocation, ventura:       "8fcdd1ec263df4eb220d3e6a36f74c4e6f433b4b7f971530115925ff4c5b4dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7c7fea38764f1d430377f9d050058ab611b3d7c8b15b59785996bc08370f9f"
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
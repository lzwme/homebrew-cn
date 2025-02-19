class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:cadence-lang.org"
  url "https:github.comonflowcadencearchiverefstagsv1.3.2.tar.gz"
  sha256 "7cc4ccd6bbd4c6e12f8e2b926b5187a70b1bcba271639f5355997fd9b7aaeb2f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c70209366e5e9fedbb2e23fdf1c218c8ea3cd524ea8f28b29021bb9b007fd3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c70209366e5e9fedbb2e23fdf1c218c8ea3cd524ea8f28b29021bb9b007fd3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c70209366e5e9fedbb2e23fdf1c218c8ea3cd524ea8f28b29021bb9b007fd3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f18a0a57664f9543909a2204de75d133b4e848c0ba55fa141234c2c0ba38803"
    sha256 cellar: :any_skip_relocation, ventura:       "3f18a0a57664f9543909a2204de75d133b4e848c0ba55fa141234c2c0ba38803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df883e079330717cdebf62e36e625e3b5538b3f3e57070878692fff81e3601c8"
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
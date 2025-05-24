class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:cadence-lang.org"
  url "https:github.comonflowcadencearchiverefstagsv1.5.0.tar.gz"
  sha256 "81165aac6d4804900a78880b99231a7620e758fe3165e53a3047bbd745e3319e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a068d6dc3ca92fb6fb45a9b8a3011df9176feb65569ef0dc8516c3a6812b702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a068d6dc3ca92fb6fb45a9b8a3011df9176feb65569ef0dc8516c3a6812b702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a068d6dc3ca92fb6fb45a9b8a3011df9176feb65569ef0dc8516c3a6812b702"
    sha256 cellar: :any_skip_relocation, sonoma:        "59e0e52b272c4edac4755829854df81be16236a7439ed1d4d447f1163baa5d37"
    sha256 cellar: :any_skip_relocation, ventura:       "59e0e52b272c4edac4755829854df81be16236a7439ed1d4d447f1163baa5d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d7545e8fa30dffd0228e95d889ec5db9d3f6d4e55c355c19473671022dd042"
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
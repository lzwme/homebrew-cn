class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:cadence-lang.org"
  url "https:github.comonflowcadencearchiverefstagsv1.0.0.tar.gz"
  sha256 "e2a67ab00bfbf568937a9f9931dff75895560e4313e660db55dd39790b3f98ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e28b50599a90b80d38bff11c2d27e488260245638cab29f26feef42ddc46fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e28b50599a90b80d38bff11c2d27e488260245638cab29f26feef42ddc46fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e28b50599a90b80d38bff11c2d27e488260245638cab29f26feef42ddc46fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1438e767cbc3670d2b0247dfe7e3e5602547c99115d488f269c0741c3a3b9f3d"
    sha256 cellar: :any_skip_relocation, ventura:       "1438e767cbc3670d2b0247dfe7e3e5602547c99115d488f269c0741c3a3b9f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab221d41be2a181655fa45efd14aa9b8afd1e570ebfb7c9a75e8980b63d6e430"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".runtimecmdmain"
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
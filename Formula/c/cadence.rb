class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "89b84b36b17c51be64644e0e3d4f3152eeb5a72ed06316168c1e4a59cde83d60"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f28726a604f1dd717beabe2956e8552d494a33022786ce52ef3a0aee71c1556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f28726a604f1dd717beabe2956e8552d494a33022786ce52ef3a0aee71c1556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f28726a604f1dd717beabe2956e8552d494a33022786ce52ef3a0aee71c1556"
    sha256 cellar: :any_skip_relocation, sonoma:        "da832ff8770c1218f58553ed77e848a5b820e68775c59d1acc0e3ceae2c5ee05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3a2c21cf247a92895348fdefbf0a37754f0fb512ff3567be22d7243f37c434e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe8e3f448dcbdf67c27aba0e111f226ac6ab4580b9a26ea2f69ad3ff0b4040e"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main"
  end

  test do
    # from https://cadence-lang.org/docs/tutorial/hello-world
    (testpath/"hello.cdc").write <<~EOS
      access(all) contract HelloWorld {

          // Declare a public (access(all)) field of type String.
          //
          // All fields must be initialized in the initializer.
          access(all) let greeting: String

          // The initializer is required if the contract contains any fields.
          init() {
              self.greeting = "Hello, World!"
          }

          // Public function that returns our friendly greeting!
          access(all) view fun hello(): String {
              return self.greeting
          }
      }
    EOS
    system bin/"cadence", "hello.cdc"
  end
end
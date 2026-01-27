class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "737ab62c8ab1cddacf9c32bacc78f0fc37608e0938b419ff6f36d05c1a58576e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecb14c66b90440e5093add6bf92413f94dc3273053848bb15407d5f3ece54e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb14c66b90440e5093add6bf92413f94dc3273053848bb15407d5f3ece54e0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb14c66b90440e5093add6bf92413f94dc3273053848bb15407d5f3ece54e0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8127638e321bed748d36f7706e43e8726a58c24370f24be57e737a30ec7f372b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34334255508a12214b6acbfc73a7caa6cf4983ade5ed62c1ab534b393a87fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c78b519c1678e3f9c12d57a4f81d232ebc7eaf69e4b8dd735a1159fede5593"
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
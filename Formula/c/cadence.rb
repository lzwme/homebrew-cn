class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "41d67530771a65bc4394160250f90b892c0889995011a54f76597064eaacf534"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce38256858402ee80e9654f1de367e76e9a9fea31141c7c68e57b7e817e32e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce38256858402ee80e9654f1de367e76e9a9fea31141c7c68e57b7e817e32e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce38256858402ee80e9654f1de367e76e9a9fea31141c7c68e57b7e817e32e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a18e10276cb5e99eb0c468dbb0bc64af449348618e58d6eee5f8dd6a3031d10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6de8a58b80f170c176cc733e78ddd86d95624f04b7b86f15623f72c49dae1c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb183b8de44d1723b7c7da9077ac5345128d95d56d0df4ff9e8ad0a4debd288"
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
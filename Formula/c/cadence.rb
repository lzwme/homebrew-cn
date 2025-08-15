class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "dfbdeb2bf54c12a01636e7d32decf73ffc4d369ac963686ae1b3c6556314af2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6e6074831d782706126eb2755f11dcbd1603490d191893898cc6528db226ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e6074831d782706126eb2755f11dcbd1603490d191893898cc6528db226ce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6e6074831d782706126eb2755f11dcbd1603490d191893898cc6528db226ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "41fdb4b6c643e06d9520954ff6a12dd3b0de3f2d6356032cc3dc65d33a483b25"
    sha256 cellar: :any_skip_relocation, ventura:       "41fdb4b6c643e06d9520954ff6a12dd3b0de3f2d6356032cc3dc65d33a483b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a01f6244491f016c5a0e28dc990e6997dc26175f635360070f2781dd921dc7"
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
class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "07aacca9a387d1e1e9c4f29cdf993fc90a8b49eba7aa3c2e076c256e3a00370d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e944a73d2b680afb239c8d884378a0b2dc0500c847a74a3f3fa3cbc89345fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e944a73d2b680afb239c8d884378a0b2dc0500c847a74a3f3fa3cbc89345fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e944a73d2b680afb239c8d884378a0b2dc0500c847a74a3f3fa3cbc89345fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "49ee9b0e27dd17d8536ce8559b67485dcac25bb552fc47e9e4a4444f2229ae27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e140e315102d79515a7e4bb0259be871232fb3bcbbbbc71407257249819a7daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e19f6939afbba93b4b14cdb2083508b02ad241c889153bc32f6c9d303fb7ef2c"
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
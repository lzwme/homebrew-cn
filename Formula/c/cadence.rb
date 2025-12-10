class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "0a100fc7438de3deb43025d027ffa861a682e88630762d8e609eb5bf20fb393c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f853a6580c1002d36a0d6ccb4755a789fdc5c9e9d9e1b45b71e7c0741eb6336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f853a6580c1002d36a0d6ccb4755a789fdc5c9e9d9e1b45b71e7c0741eb6336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f853a6580c1002d36a0d6ccb4755a789fdc5c9e9d9e1b45b71e7c0741eb6336"
    sha256 cellar: :any_skip_relocation, sonoma:        "63177a958c1e35abec4f3ee205ecc4e3dd8f2b75ec544284daaa3a5a2cbd436e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ad3b2a269c595ee8999d249dcdd494b4884ddd3179601663f145ef540e94f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e13dc28a662ccfca34e3c60481417fc084e1c3d8d29085cc839380ca19fc560"
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
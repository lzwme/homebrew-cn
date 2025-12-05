class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "c86ac778e412faeb4b19a9178e47d27e5015f7178e06ac86c7646ab0288e1161"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8647d5fea26857abded96beac59dde25843e5e7e119e81c0100c6b48503ac57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8647d5fea26857abded96beac59dde25843e5e7e119e81c0100c6b48503ac57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8647d5fea26857abded96beac59dde25843e5e7e119e81c0100c6b48503ac57"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d114105160e09bd27c167d7a0098a65cae09b36ea8b294903cb03c15dbb61f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f58bda543ca9e11705c51ba60a2410ec836197317c5f49d9d286b583a7cf205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e913231ddc02d5c1e1c14fe4c38bb02cc4c1c9f4c8e0d5d4edeb1fe418a746a"
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
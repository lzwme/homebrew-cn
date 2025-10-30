class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "37f957e90c9c5acae3ac09a0f530d8376f2e307d073af615fbe56566e3443431"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21623762ba5d5e85b6725f6d90e552d2c7a292d46d4451069454795a1c6163c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21623762ba5d5e85b6725f6d90e552d2c7a292d46d4451069454795a1c6163c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21623762ba5d5e85b6725f6d90e552d2c7a292d46d4451069454795a1c6163c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad985983609871e67ef317d2bef1e686fc10ff94bf49fe5bdf6937f2da2d47cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e978007a619cec91b35bafeb00da63ff3c2a7ca4cafdce64c64a00152153ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24134bd7a94e55a0787674b1734be3cb9b16a5501169994dd0f7814111048049"
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
class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "2d13cf15344ca5b350faed4868efe1e347daf3a54db00d754eac580045d8956b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8aba07b42dc67ae544ceaf156f945da6b72aec6c3111850a4a084a347ea2d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8aba07b42dc67ae544ceaf156f945da6b72aec6c3111850a4a084a347ea2d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8aba07b42dc67ae544ceaf156f945da6b72aec6c3111850a4a084a347ea2d26"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a50118dbfa07c339eacf726edb40bbe5898147943d7735978bad0f45585d37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64f2a03fde38e78f4f95ee11ffb307981e822bd7639dfafb4d1455f668445570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5cfe6bc80a55855cba9e4bdfe71424d4daac94fdd1fb3362362c86d76376b1"
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
class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "a46b70c3eaab6e100f544b502f5a2f68716b4fcf7bfa64e3252b313c6768179e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1184bcfa3187fb0a11df6e0ed1da014a428c5815c6cea95ba75262b9ef527d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1184bcfa3187fb0a11df6e0ed1da014a428c5815c6cea95ba75262b9ef527d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1184bcfa3187fb0a11df6e0ed1da014a428c5815c6cea95ba75262b9ef527d67"
    sha256 cellar: :any_skip_relocation, sonoma:        "f986ce5f5bbe82a8c59644a3e2c4d618c6e7a0debf1932fad76e90ff0135340b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcbf1f6b580705b081655cf3da9a59abe51436c98512b788921b7f052ca7cc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d36252fe54229e5f89524182714859d4605c8a711c956aad4b0f6ce0a7f19830"
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
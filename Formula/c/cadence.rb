class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.8.tar.gz"
  sha256 "29ba0d29077078f13a89da928aedae816af131bca0a4449f9a6cced76ae6c4fb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "977501368e5a796676acce039187a989b22f0cd1add3a6b90ca4944f195d330a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "977501368e5a796676acce039187a989b22f0cd1add3a6b90ca4944f195d330a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977501368e5a796676acce039187a989b22f0cd1add3a6b90ca4944f195d330a"
    sha256 cellar: :any_skip_relocation, sonoma:        "111168c97d2d53226ac39d7fb2c9db166c542e0cc00aa937f5c50846804cec3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b613a2f4a9d94a2d482dd51cc113462c10f0f67d6042097babaa14b830ff808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b110e3e8917539452e5e695b58f873968e2ad36c10a0311c1a345995228f3b"
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
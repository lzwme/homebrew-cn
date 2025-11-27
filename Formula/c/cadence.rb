class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "f9f8994e8d81bba8fc16f332faeed3a952672e471573f55660b90470f4aaef2c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53bbc27cfa00790f541c243204feeaac91b5093c9e1e5dcc49abc58c10c5b679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bbc27cfa00790f541c243204feeaac91b5093c9e1e5dcc49abc58c10c5b679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53bbc27cfa00790f541c243204feeaac91b5093c9e1e5dcc49abc58c10c5b679"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fa9931bf168063d443a8825903ec4114057f07900cef2b7240344ac37ccc27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f3154a9f06291dd59c442e3f0e5bd3500f0af64affb9a462a13e152b35d188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5967d9306ab6b3bddecf4a5785a0be0e65911a6b850aa4916fb9c6948f55db7"
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
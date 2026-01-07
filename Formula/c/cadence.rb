class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://cadence-lang.org/"
  url "https://ghfast.top/https://github.com/onflow/cadence/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "50d4b88c5537ec15fe7fafb4364d6f2508d3a0e06eb62a4e3a58ebbb2ffc33be"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09fbf190651ab534ad31044b62d8e6594bb7d7d430bf2060015a3d7856dcd26a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09fbf190651ab534ad31044b62d8e6594bb7d7d430bf2060015a3d7856dcd26a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09fbf190651ab534ad31044b62d8e6594bb7d7d430bf2060015a3d7856dcd26a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a03bd75d5746860b0d6a82b2800b9b38d6f88b3221d0d0ecd6834515137736e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ea03349bacb2d0b67dfc42bb6693854ad99046858656042707c3394ea944aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbc1c0fdb5d1a3a43b90055029e0c03e9422a9f6b71a18af976eb16e6d5698f"
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
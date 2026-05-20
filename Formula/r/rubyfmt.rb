class Rubyfmt < Formula
  desc "Ruby autoformatter"
  homepage "https://github.com/fables-tales/rubyfmt"
  url "https://ghfast.top/https://github.com/fables-tales/rubyfmt/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9cf70038b8e2773c119dfee342575249b3c1e111cc1947b3388921f2588f064e"
  license "MIT"
  head "https://github.com/fables-tales/rubyfmt.git", branch: "trunk"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "245aea3ebcb5ec7a9c55295165d6ead56f604b00e83bf632a9d0317aa4ffb54c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41a7c95226ef73450cdb2568220874bd89f5bc374c7a147de26cea4906115ec7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6324fb3c64bfa9f3515bedca3682e54d9f462d7f423355e960c3abfe84397e52"
    sha256 cellar: :any_skip_relocation, sonoma:        "21eb8703efeaa4b947845bf26b900699c30694667c65c756e6d4d9cb7d0cf705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "707a455e8b162629f11dfef054c546d472bdaf2b7df222f0b02e39643a784d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dc1ff36c88b6d3e3dc7bc90bd2f04b76844f4009b60659e58fae09d09ce49c9"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm" => :build # for libclang to build ruby-prism-sys

  def install
    system "cargo", "install", *std_cargo_args
    bin.install bin/"rubyfmt-main" => "rubyfmt"
  end

  test do
    (testpath/"test.rb").write <<~RUBY
      def foo; 42; end
    RUBY
    expected = <<~RUBY
      def foo
        42
      end
    RUBY
    assert_equal expected, shell_output("#{bin}/rubyfmt -- #{testpath}/test.rb")
  end
end
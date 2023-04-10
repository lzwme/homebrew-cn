class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "e2b0eaf122a023fea81ac7121db16090027f840a67b1141e574857897627e8f8"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "763d453ac27b2831db6bf41e128bf114cfb1e7a7b9784ff0da5a215dc605dd5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d079d3ee6817009b65522fc7e0fd0a7d036be59fd5ddd7cc7f45f6a65171dbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d837a9fa3197908fa4fccb64ca362a72d7a4360a3b3895d86d44c6332928e49e"
    sha256 cellar: :any_skip_relocation, ventura:        "e4d20cb8ebf14444ad25ecf8845cf82365f3e3ba2d88c7b4f11c2a28f36c72d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f03667af7ff5670593368bd8729ee44f770b875c6554ba2098c0f3541328ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b56f98d52c63300a566ba32c96cf534957a41a80c538d9463c60b68da667716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3bcb1ba79a72ed70122a5b3053f16ed89b440e12bf8121b88ec078482cea25"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
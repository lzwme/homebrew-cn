class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "b37484ae2a42c6662381fa22a0e74a1e979900750053f34e0cf0f749c1b9cce2"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24d911d236dd84c0130ae684c066eacc5d267ef50fd2d4f7d931e125ef5e92f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39488499159e6e2620aa955c55cb53dc5e4c274f600582eca095bd590a7c5d16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f12975ee31ff3d6ad0371fbcd27f9d7e9948f8b1d0664cf8c465f5db17f2a26a"
    sha256 cellar: :any_skip_relocation, ventura:        "2c221660c78a2db22839e1f607ae905097aa5febfc462f0e77f2e50ffc0a658c"
    sha256 cellar: :any_skip_relocation, monterey:       "eb44e5a5d212eaedb7aa4256f47a28d42f71fa529f14c4a6f26fb9b8caf92faa"
    sha256 cellar: :any_skip_relocation, big_sur:        "48c458468a12fdf451ee1e6b8f797636ca80713c63395d8949f335a0d87261d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a620f604c2a05e24f97fb682afe25b040b8e775f89f52fcb77a2516f6d63646e"
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
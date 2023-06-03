class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://ghproxy.com/https://github.com/jdxcode/rtx/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "33459a150a563444fd5e08e89cc821148e6164c5b2837bd72166c30843dc0987"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f05730aefc8c3aadda4cd2abff25fad6cf9be16bc5f83ecd4fd131c7fdebf325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edddebf20354596d813a00833ff834eb471a04b9fd20ac728806f6ecd1bac644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "628e47f8947e39278123b866ded68813ff772c62a4b9d86197a74efc16cef8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "58e2d76e95e60ab5ed5bd961f44a587acb0f296d6458e4c0a766fa9ba729e057"
    sha256 cellar: :any_skip_relocation, monterey:       "85a780e4aa4582cec8b2a5863345865d120fe9a8f5e9f7f5b8bf9d0f9189ff04"
    sha256 cellar: :any_skip_relocation, big_sur:        "7795d6a91b7ce1d1e81dc88a69e166e061c6ce580a5c8f752b2b61b211eecf51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a89e9cb79a7f9a15ef1e481b07e816cef7d952cf303ddad9617916c7d413f2"
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
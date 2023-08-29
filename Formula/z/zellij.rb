class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghproxy.com/https://github.com/zellij-org/zellij/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "d575c693f91a5ba502b356fda68e444f65904505532908eae7e8efd44ce1c2f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9791bfe55eebfe28d1e17a2c0ac73e13610406f9dc6a427a18afb5aaba37add3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "609cc2e267bb4fa69e2110fae8bcdb8d67da4aaff5f955295f4477c2e749ddbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93e305c89923d1b264ba5c85426011396b27c74a8a7f6a2921054f748e541202"
    sha256 cellar: :any_skip_relocation, ventura:        "e3b8c7b76d810d8f8d095c994ee6d60db1203d29e420e720c7a6b653c2d31f89"
    sha256 cellar: :any_skip_relocation, monterey:       "a58385dca68a825ceca747fe788e5f78b67011d5aa2870e3880f17df3ac073e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "97b422e6b5ebed6f4350188ae6201512bef29bacb285a6b1731276fc4b300d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b0ba9329668e0e780d3dede30bd9afb6f304965096f02147b11f108fe5fe8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
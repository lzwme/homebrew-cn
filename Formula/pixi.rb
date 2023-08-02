class Pixi < Formula
  desc "Package management made easy"
  homepage "https://github.com/prefix-dev/pixi"
  url "https://ghproxy.com/https://github.com/prefix-dev/pixi/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "4b9da58d99a6f51935ac1e1e3920331ae457c71127929e31444e32cb294ad2c2"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a54dc13ab3cc4ef2acdd1faa06b26f614496aae02b54e83595c63dd89e5c4944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1a8953dcc9f9abcef91f53f4013f143f20577fd251c894fa89ee6e751cb78f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33ca3954d812c17fc0dbecc980624580ae5d31bdd0516189b45c898433a453fc"
    sha256 cellar: :any_skip_relocation, ventura:        "7f2edf26c1ac1c0c0c59ea01192c1a9a7712048efe82fbfc0634fddc47c482ec"
    sha256 cellar: :any_skip_relocation, monterey:       "edf538d381957e33ddb2facbe18f969b97559b2f2229ad13e7f208cb3e2c1c4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "65242368e8c2897b16945b132dca4eb9466d7d5c9476bcf1c574a82869149de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e67f9fd512c1e31a859e8f813973e754bffb9fb3ef573a126f69c62310e6451"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
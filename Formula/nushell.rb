class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://ghproxy.com/https://github.com/nushell/nushell/archive/0.83.0.tar.gz"
  sha256 "49be7fdd34512e877ca18345f7be84606db601a657f8235dff670a66fff5b82c"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85e7ce30dcae01040ed1a44a5bee5268b6e9da4eb50ee8039d1c770374d69b47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a8ae44cb0947047a65cc85f5df1f61e04f25f29f8b2a5d81b6e525b806704c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3b8968dd4e09e67cf4c1edf2a83683ac93da83f0f21b5e3b7ff42d2bf698925"
    sha256 cellar: :any_skip_relocation, ventura:        "0b879503f611d197311130062560cd54028ed9096a02daefa38a8c23c6e20259"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7fe039a3b58178a6eca0229c8c72ae234a442b1dc448de628a7b76c23e312f"
    sha256 cellar: :any_skip_relocation, big_sur:        "37caa75daf1736dc6345a8713f732ab50f1b0f98888381bffbc9d7554ed2acb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4b92d57ad7ca234d3b9f46aefc6f9960101fb444c85574fab05df9a4eddcce"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
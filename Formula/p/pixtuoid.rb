class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://ghfast.top/https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "48455b07618e4ea25f2cc46449950c4aec63b31f34d01adcb4bbc9e8e36ceff0"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "676b40d661440f980d03341c6e2625c0ad0465dbc7e68a39360de7569ecfb5f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93915b6c3dbb68ea266401d674b87a59b430e58d983cb6e72f3990a131364831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b03594f1e5ad8eb5f85ba6654df8dd2690a6c2fe6fdac271345465e35eb8663e"
    sha256 cellar: :any,                 arm64_linux:   "05c519ef803803fb215ec308aa2b830436c363ccdbfc66e02d1ed72bf462a681"
    sha256 cellar: :any,                 x86_64_linux:  "464ece7a978914d4c8c6b88ebc4e2583587a76e587911e54b3c8db8c1cf146ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Drop upstream's x86_64 Linux lld linker pin
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid")
    system "cargo", "install", *std_cargo_args(path: "crates/pixtuoid-hook")

    (man1/"pixtuoid.1").write Utils.safe_popen_read(bin/"pixtuoid", "man")
    generate_completions_from_executable(bin/"pixtuoid", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pixtuoid --version")

    system bin/"pixtuoid", "init-pack", testpath/"pack"
    assert_match "OK: pack \"skeleton\"", shell_output("#{bin}/pixtuoid validate-pack #{testpath}/pack")

    require "json"
    connected = JSON.parse(shell_output("#{bin}/pixtuoid connect claude-code --json"))
    assert_equal [{ "id" => "claude-code", "outcome" => "connected" }], connected
    assert_match "pixtuoid-hook", (testpath/".claude/settings.json").read
  end
end
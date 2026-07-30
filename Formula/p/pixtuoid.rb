class Pixtuoid < Formula
  desc "Terminal pixel-art office for AI coding agents"
  homepage "https://github.com/IvanWng97/pixtuoid"
  url "https://ghfast.top/https://github.com/IvanWng97/pixtuoid/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "3ea09fca426234ec7a311bacb683320b74442474413ebab81a7c1134abd80ab5"
  license "MIT"
  head "https://github.com/IvanWng97/pixtuoid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d22ee48f1c9f14fce99897e578a682855744f7b8e284b6d8df96a2b9511c16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a390e933070cf08315f7ea2a2b03dec79d9214f6691a5fba163b707e4ddfd2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d858b43eb6eddb7dd2216d9faee2908586dcaeb6862db64d5793ea1d3e0eabb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f0f1112b37f5b7fdbe9121dc43842b06cbb9d5d590d0c02ef196667b0ad76f3"
    sha256 cellar: :any,                 arm64_linux:   "5cc259128e9b92ca682e33793afd8d4947e5ab15843abf1109bd997366dad4de"
    sha256 cellar: :any,                 x86_64_linux:  "138917a4c040626e93fb88f90b7c3f40a132a56192aaace5aea75eab42fc94e9"
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
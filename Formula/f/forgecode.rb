class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.9.tar.gz"
  sha256 "03adfc3d78cac3044cac5b5b03f4df3e0d2a2c2de4222bae113801877a22b1d7"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd26753e39f18440ea4e0ddf6110f8d25c6c4fe8b1e2c8f9b4702c02e45d879c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f37ade73ea9530784e82d7fc68b9d7eaa6c4267e90f739e040006ceaac65abe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38289bca88a7bdd5d60a6709cc7b9a4c01b969c3173c10cfaa861cb56a0dd744"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fa1f69ca71131a59d33fae29672445aa5d86b0fba8034ff82dc8aaa256a18c1"
    sha256 cellar: :any,                 arm64_linux:   "a508f6cdd9827923dc0b6f0222d25cc68b28d5b9fc74b3c2f12934d833c64446"
    sha256 cellar: :any,                 x86_64_linux:  "56f96954b9bd163ff938eb6e2ede3e239069728e3d144016b83efcd908821cc3"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://ghfast.top/https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "90b035d0d41fe166e5a5ce18668d1c3098a7e64c17fcb8bfc7a3ba11c24019a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72284640a7b7d46057e20a316dc5a443e8b9aa1c8a4bcb3ecb769b4bd826dd33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07fe020900cdd4873f466b5bd266647d5995fd4f3e97a4613bada184b5a053c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cf4d0ef6810420b5dff9e7cb17d2527157bce268352a8912ec21f987fa4d4ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "631d5a84525d68b93da843f511b1747960f3e165afd13bfbf3a201bac07bf880"
    sha256 cellar: :any_skip_relocation, ventura:       "ba42e3aaa2d14dbd07e47156d5453e67164dd05c92032fde2077fe3368ec46a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7003b0b7c5f9e72a6ca6b6c3f52efd569aeefa3f31c14278c762895190dc4ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0c139aaab9231c38cad560da0f9a7c44b4a148b440660655607a06d379996b"
  end

  depends_on "rust" => :build

  depends_on "rustup"
  depends_on "wasm-pack"

  def install
    system "cargo", "install", "--features", "bin", *std_cargo_args
    pkgshare.install "fixtures"
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    system bin/"tinysearch", pkgshare/"fixtures/index.json"
    assert_path_exists testpath/"wasm_output/tinysearch_engine.wasm"
    assert_match "TinySearch WASM Demo", (testpath/"wasm_output/demo.html").read
  end
end
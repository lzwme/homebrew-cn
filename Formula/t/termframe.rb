class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://ghfast.top/https://github.com/pamburus/termframe/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "7e9fe9b19da85eb1b2cd7d644b4a2d74cdda7c5e4ae4b01dc3eb1f61acc3b482"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8cf87f422b485583fe6a5628e158f7be664c153fbe1f27fd5d732aca87783f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421a247e1f3e2b9ce771c67cebeda0fb660c3e09ccc7cb8a302bb0946163a2ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a24665dfe58ac246e7d7d1e89b9ad973255cc1432e58054f0025564c5012627"
    sha256 cellar: :any_skip_relocation, sonoma:        "af113cc986ab1502aa1c94d73abed53a3d652eb08fe92dce53b9e3c66109bc06"
    sha256 cellar: :any,                 arm64_linux:   "e563647a1bebae14a4ec71f783d5c69dbd21a6f456f62fb63b21ec88c6c3e3b9"
    sha256 cellar: :any,                 x86_64_linux:  "ea221016f2e1f3ea4fd4803d93c6fdf5b8ca8fe9bfad208e7f83198b14eb9be7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
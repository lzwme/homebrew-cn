class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "2373b23210b6bb6bea731382a7d9b454a9ffb02f3b84570740fb896503eef42b"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5762f734ec9fa047f71bd977f402162d0f214c79192015926686686d9511e163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77004ad1276d3b4357b9f8498255c90b4d898251daa4079fb37342c553d4b298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae47a72d52eaf58a819589a611c4a70ca0dea13d9967e7826060b0b25bc1717e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c03295806a4433e37a9a96b5f4654ef006d6e39a2acfef696202ae0dbd9840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab291fb27175defbdd72794ae7de0955ebd11ba3798e21d835b601f4c96a12f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1290f7bef57063bd5849b91f70e90cd7ed2d24c6717b92d6e4593a162699f4c9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
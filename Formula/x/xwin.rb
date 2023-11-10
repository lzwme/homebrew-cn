class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://ghproxy.com/https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.4.1.tar.gz"
  sha256 "db3739d8e806b57f61b8b4d11e2827f9df24148649a21ac7a49df4ffd5952874"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "215faeb9c53592bcfc31d41baa2bbd72c9f4f1edb16f9314d027c6d273b07a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f43f744d663527207cdce737d397a28c38b6f47d42d16067ac14dea0d97a6b6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503b6ddc6e405ea05bd8fbe1bce6cacb61432148e788aad9c9cf1914f586dc83"
    sha256 cellar: :any_skip_relocation, sonoma:         "48020dd9a02c73b8baabfec01701910d26c0b9f4b08e9eb176d8705ce04b7efd"
    sha256 cellar: :any_skip_relocation, ventura:        "9ca3eab430194aff205c1ed947bcda18215510880a22d0cb147553a429177128"
    sha256 cellar: :any_skip_relocation, monterey:       "c2262041688f2b57154f8d06a2c851978fb52d842b1441f0e5158f24ff5abe6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40e682b44cc724ad654984846e7da436b52e54b8a700f32781b90eb1cb1f65a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
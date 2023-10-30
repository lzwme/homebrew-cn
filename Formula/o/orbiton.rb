class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://ghproxy.com/https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.3.tar.gz"
  sha256 "383e3a14b416530478250e69d1de1c71aedba7bd3304c53e965638edaed768da"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db7f586c3c22967fc5c6d3d88df042daa9ab1a03c7621fd976346d44f1e1de96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f72f553506547a5ebbee306e4eebc4f545616992d7bc3b6e07b9fb01d16a8f76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29a240ce1c17dbdbd7c8c22bf9a65fc5116b261bd02e00a9bc042583f070c33d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3de41e603d03a445dff02dd01fa6b8e665a4ec8717aea48dbba2a42f156d5a8"
    sha256 cellar: :any_skip_relocation, ventura:        "94a72dbac9a77068d6d5087e7d6a53cb402b1ce5c2c424a86258d456095510e0"
    sha256 cellar: :any_skip_relocation, monterey:       "aaccc7dea21ee356b272d1f5f8778a4e682dc3c332f596e3b8c63629b9d4fbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4262e334baa0b9e2f2a02b2c446cd07354a1a3d68dc9d5784c5ba1f982e6eac6"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "xclip"
  end

  def install
    system "make", "install", "symlinks", "license", "DESTDIR=", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"hello.txt").write "hello\n"
    copy_command = "#{bin}/o --copy #{testpath}/hello.txt"
    paste_command = "#{bin}/o --paste #{testpath}/hello2.txt"

    if OS.linux?
      system "xvfb-run", "sh", "-c", "#{copy_command} && #{paste_command}"
    else
      system copy_command
      system paste_command
    end

    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
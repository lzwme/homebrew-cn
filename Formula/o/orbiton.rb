class Orbiton < Formula
  desc "Fast and config-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  url "https://ghproxy.com/https://github.com/xyproto/orbiton/archive/refs/tags/v2.65.4.tar.gz"
  sha256 "b082fa9a29ec925698ae887ced57f46cddb48ac32b42bbc1f97f6852692ec5e3"
  license "BSD-3-Clause"
  head "https://github.com/xyproto/orbiton.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd488fee7074e471049f572903a52654fb5c42469ccc75ee68d66aff9799df31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b47a3f187e969c7cf86495aff2a6f23e2ce0c0a66af573cdb8100f4dce6608f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f91cb42e228367a94dd4084599e92cd2826aad13a978cb2d4f215aa6db385cbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bee70ab88bda4827ed0f0afc858d78662a1bef7d5cceb0d5218cecdaec0a2d2"
    sha256 cellar: :any_skip_relocation, ventura:        "ff26d748ca9c8bbb118ae932289133f24a703d3de62c3cf9f653d44e4d2c357a"
    sha256 cellar: :any_skip_relocation, monterey:       "4647793f58a8fb38b76d4e59b584ffcfe5cd14ea71b2dd2af89e261145c4cb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f0208dd525afbd013161cdf84657941c91341e7cbecf0738dc6e43110d147e5"
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
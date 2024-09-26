class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.3.0.tar.gz"
  sha256 "e1c2741e7cbcdcb6152ad4251f032aa9ea3b77e96ce84f760a3265dc7c56ae5c"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba612dc3b81fa03de875455c1ed7b67187468cac62f522e76a041f2c482a12b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2d8aac289a5a94dda9ead1051dcca504c40c93fe0f0ead2f10c581c26d0b74a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48b411c30ebfdded88f5738487c075eca978b886a83781075cacd7529934c4f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fde22f9284b969a083c80af6534915961ef27087280ef9ee941be9d268b8f7"
    sha256 cellar: :any_skip_relocation, ventura:       "0bb0b08d7cddf735dcb251248b032fc6e39c1c61be38f2f7f3e69c985d13e17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee490a0f77f5c321cd9ea77ce0a6c838a4852f53f0d0b4179217a1782030055b"
  end

  depends_on "ninja"
  depends_on "pkg-config"

  def install
    system "./bootstrap.sh", "build"
    system "./build/muon", "setup", "-Dprefix=#{prefix}", "build"
    system "ninja", "-C", "build"
    system "./build/muon", "-C", "build", "install"
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin/"muon", "setup", "build"
    assert_predicate testpath/"build/build.ninja", :exist?

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
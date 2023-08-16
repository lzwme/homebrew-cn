class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://ghproxy.com/https://github.com/vasi/pixz/releases/download/v1.0.7/pixz-1.0.7.tar.gz"
  sha256 "d1b6de1c0399e54cbd18321b8091bbffef6d209ec136d4466f398689f62c3b5f"
  license "BSD-2-Clause"
  head "https://github.com/vasi/pixz.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8b8196d1d48f4104e40bd0963e7ffa5eca16e4499b746802fb55ff528e2fad25"
    sha256 cellar: :any,                 arm64_monterey: "c4b1e3fe61fa37f1e6854d8adc032e18d16093b17060a97cd81f421bf9b1c9fc"
    sha256 cellar: :any,                 arm64_big_sur:  "7a61cbb0485e22375ce03a81089da37f34aac406a14447856e7f81b7240a1b86"
    sha256 cellar: :any,                 ventura:        "b76e0ef617047c5db1d634e87630904018c01d89468576c50fced29b08887f85"
    sha256 cellar: :any,                 monterey:       "e106250f6eee640ca6061f55ff2339539c2047325d878478bd7e5c5acf354d08"
    sha256 cellar: :any,                 big_sur:        "088fd95bfc5540586369b0adb35f6f37009b1f30d4b29de58342828202b8317e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a110294724b79c7a130b3705c91d25fa52e01f7cf6655d486a0901ada6d6b24"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "xz"

  uses_from_macos "libxslt"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "a2x", "--doctype", "manpage", "--format", "manpage", "src/pixz.1.asciidoc"
    man1.install "src/pixz.1"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    testfile = testpath/"file.txt"
    testfile.write "foo"
    system "#{bin}/pixz", testfile, "#{testpath}/file.xz"
  end
end
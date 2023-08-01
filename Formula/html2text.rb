class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "https://github.com/grobian/html2text"
  url "https://ghproxy.com/https://github.com/grobian/html2text/releases/download/v2.2.2/html2text-2.2.2.tar.gz"
  sha256 "7afb9c5cec4e27b69a50f082770eae09a0e5f081809b29975be2907176645a60"
  license "GPL-2.0-or-later"
  head "https://github.com/grobian/html2text.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36b703470b326e0d431ef81c205ea56f8c6a8b47ad9ae9a0ef90222b616fec9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7286f1f14e7ba929587bdda62d84adf5609d98f1fee6fdc5361676edaf3de3e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da5d0859a5bcb6b4fd9f8397052157dba9ef6e03c2611809177b08a6f51599fc"
    sha256 cellar: :any_skip_relocation, ventura:        "2cba01d8b693cf02d57119afe4c9ee96e326b88967c503c6f45ad5c693bf2ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "4f18c6355f43538f7798f18bc1304c7352c1b1107eb43adf2782a5425e5a2350"
    sha256 cellar: :any_skip_relocation, big_sur:        "381dfc664c6bf8be24282f6e41a09d7d8b4b101536b32fc7bd0e540b1855a147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0971ff6db8edc0aaacaee9e305a4a5331a5d28130882589a9c220886e5fbec44"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}", "BINDIR=#{bin}", "MANDIR=#{man}", "DOCDIR=#{doc}"
  end

  test do
    path = testpath/"index.html"
    path.write <<~EOS
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    EOS

    output = `#{bin}/html2text #{path}`.strip
    assert_equal "Hello World", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
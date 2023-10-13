class Libretls < Formula
  desc "Libtls for OpenSSL"
  homepage "https://git.causal.agency/libretls/about/"
  url "https://causal.agency/libretls/libretls-3.8.1.tar.gz"
  sha256 "3bc9fc0e61827ee2f608e5e44993a8fda6d610b80a1e01a9c75610cc292997b5"
  license "ISC"

  livecheck do
    url "https://causal.agency/libretls/"
    regex(/href=.*?libretls[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45109b58836fd475c43f0d0dc84c01651c4f6da03732dc7e8c75d6bef69f1a0a"
    sha256 cellar: :any,                 arm64_ventura:  "c64160d3f1e8351158fe0e6d341e622f877df3e8f1dfc9e5033d5a46603641e3"
    sha256 cellar: :any,                 arm64_monterey: "27a4b439b4074f1563e89a1cba25f527697b31a80c9b8cd8bbbb4a835d143b90"
    sha256 cellar: :any,                 sonoma:         "73bf7016f11e9ac566bab92a996855e0b324ca455aeffeb80c4625b40e06bd18"
    sha256 cellar: :any,                 ventura:        "b6b3b3ecdd3815d542edf2501309a30568e1e03b35e1c793e0b724324c0925c5"
    sha256 cellar: :any,                 monterey:       "9d52d3007f279b514bfda52afd77bd06f0a420d8daa8ab2ef697b618c5b4666f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44fe94119c4fd8be706393a1b2818af2e7851985fc3ec7dc4ebec2aa2045697e"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tls.h>
      int main() {
        return tls_init();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltls"
    system "./test"
  end
end
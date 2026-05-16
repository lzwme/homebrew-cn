class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.6.4.tar.bz2"
  sha256 "f1d6d3e8e79933e9e03dd9f342673f31274686a29d295e7cb34558755d224670"
  license all_of: [
    "Artistic-2.0",
    "Zlib", # zlib/
    :public_domain, # librcksum/md4.c, libzsync/sha1.c, zlib/inflate.c
  ]

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a6472a6c5db07355418baa9806763ed9c042f91c15a5df87ac2b6c59becbc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c591c6cde4e285d18d3c63952b55ab4b81fcc3d25b4920c57be4edb416550d8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1475d54229d78f6a6ea23479ea2df033d9a1f838237c1bfd81d57d1b34328600"
    sha256 cellar: :any_skip_relocation, sonoma:        "e42a2e9acd88b9889d6ae579ef334cf20f7380962da450d226f9f41c44582f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a991cbdc03c6fb9c7a1114802fb5e151f0440ebe1c8173d6f2c178b56ea5eea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f85547fa385ae58296367abbf2b01816514315f54ef3f41fc387e1c41263a4"
  end

  head do
    url "https://github.com/cph6/zsync.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    if head?
      cd "c"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Limit C to the latest standard that supports K&R function definitions
    ENV.append_to_cflags "-std=gnu17"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    touch testpath/"foo"
    system bin/"zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_match "SHA-1: #{sha1}", (testpath/"foo.zsync").read
  end
end
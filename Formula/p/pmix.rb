class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.github.io/"
  license "BSD-3-Clause"

  stable do
    url "https://ghfast.top/https://github.com/openpmix/openpmix/releases/download/v5.0.10/pmix-5.0.10.tar.bz2"
    sha256 "78663f6b932589d68e24feaf7f8a948d60be68d91965f3effbacb4cd88cf9a95"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "56c2785cbeb51b3bf0fc950f98f553521e60050fd0c5d36620e07f528a26ace0"
    sha256 arm64_sequoia: "391f5cea8dcc65ad8d1fa75114a89da05c814591c3e6f3886df1fb720e84a639"
    sha256 arm64_sonoma:  "59095213991c4af37c293f7488ff3ebb70d7ae11baa5671d73c5169ea407860c"
    sha256 sonoma:        "cadd5c07187b2747f85fa7496f5d12d4879fe790c929d59b14cd04a000549b81"
    sha256 arm64_linux:   "51454dafd8c88ccdb2e4b762da58da655d85f1442b436f3833b4fc5d47522e02"
    sha256 x86_64_linux:  "4bbd504b46145a5d913ce38cd67bb67bd7aec93c1afa3dabc000d4a988b6df20"
  end

  head do
    url "https://github.com/openpmix/openpmix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    # Avoid references to the Homebrew shims directory
    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace "src/tools/pmix_info/support.c", "PMIX_CC_ABSOLUTE", "\"#{cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <pmix.h>

      int main(int argc, char **argv) {
        pmix_value_t *val;
        pmix_proc_t myproc;
        pmix_status_t rc;

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpmix", "-o", "test"
    system "./test"

    assert_match "PMIX: #{version}", shell_output("#{bin}/pmix_info --pretty-print")
  end
end
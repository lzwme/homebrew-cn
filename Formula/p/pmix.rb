class Pmix < Formula
  desc "Process Management Interface for HPC environments"
  homepage "https://openpmix.org/"
  license "BSD-3-Clause-Open-MPI"
  compatibility_version 1

  stable do
    url "https://ghfast.top/https://github.com/openpmix/openpmix/releases/download/v5.0.11/pmix-5.0.11.tar.bz2"
    sha256 "e10baa9821882140ebd134051702d65b1561fe91954d3978f7ea2c4e4cd36e7f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      file "Patches/libtool/configure-big_sur.diff"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "349e2cc29d337be93e5fd21302288b9109227c45af72aa001461ababee2a16c3"
    sha256 arm64_sequoia: "4fd1aa9ff69f21c4cef249d9365ab83dd87fe996b8999ed82afe89950e00e9c1"
    sha256 arm64_sonoma:  "ce93fd532c984178171e4a00d1c87f76d38c37f7d80c3ce1c7caad0be1896460"
    sha256 sonoma:        "ae2d7f30805f85372aa20e244bf0632165bdbca13dd4706894b08488f1413d68"
    sha256 arm64_linux:   "1ab54667fb9cea88b75918eb66b3a01efeab9391e17c269feb1a51fec7677010"
    sha256 x86_64_linux:  "2e5e5e0b9239a916745eaa575ff76849f945efa7fe8d8870091b29dffb78c8ae"
  end

  head do
    url "https://github.com/openpmix/openpmix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    uses_from_macos "flex" => :build
    uses_from_macos "python" => :build
  end

  depends_on "hwloc"
  depends_on "libevent"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Avoid references to the Homebrew shims directory
    inreplace "src/tools/pmix_info/support.c", "PMIX_CC_ABSOLUTE", "\"#{ENV.cc}\""

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --sysconfdir=#{etc}
      --with-hwloc=#{formula_opt_prefix("hwloc")}
      --with-libevent=#{formula_opt_prefix("libevent")}
      --with-sge
    ]

    system "./autogen.pl", "--force" if build.head?
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Based on https://github.com/openpmix/openpmix/blob/master/examples/simple.c
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <stdlib.h>
      #include <pmix.h>

      static pmix_proc_t myproc;

      int main(void) {
        pmix_status_t rc;

        if (PMIX_SUCCESS != (rc = PMIx_Init(&myproc, NULL, 0))) {
          if (PMIX_ERR_UNREACH != rc) {
            fprintf(stderr, "Client ns %s rank %d: PMIx_Init failed: %s\n", myproc.nspace, myproc.rank,
                    PMIx_Error_string(rc));
            return 1;
          }
        }

        rc = PMIx_Finalize(NULL, 0);
        if (PMIX_SUCCESS != rc) {
          fprintf(stderr, "Finalize failed: %s\n", PMIx_Error_string(rc));
        }

        fflush(stderr);
        return rc;
      }
    C

    system bin/"pmixcc", "test.c", "-o", "test"
    system "./test"

    assert_match "PMIX: #{version}", shell_output("#{bin}/pmix_info --pretty-print")
  end
end
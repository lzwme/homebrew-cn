class Ghc < Formula
  desc "Glorious Glasgow Haskell Compilation System"
  homepage "https://haskell.org/ghc/"
  # We build bundled copies of libffi and GMP so GHC inherits the licenses
  license all_of: [
    "BSD-3-Clause",
    "MIT", # libffi
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"], # GMP
  ]
  head "https://gitlab.haskell.org/ghc/ghc.git", branch: "master"

  stable do
    url "https://downloads.haskell.org/~ghc/9.10.1/ghc-9.10.1-src.tar.xz"
    sha256 "bf386a302d4ee054791ffd51748900f15d71760fd199157922d120cc1f89e2f7"

    # Backport fix to avoid unnecessary `alex` dependency
    patch do
      url "https://gitlab.haskell.org/ghc/ghc/-/commit/aba2c9d4728262cd9a2d711eded9050ac131c6c1.diff"
      sha256 "152cd2711a7e103bbf0526dc62e51b437e6c60e26149f2cd50ccafaa057316ce"
    end
  end

  livecheck do
    url "https://www.haskell.org/ghc/download.html"
    regex(/href=.*?download[._-]ghc[._-][^"' >]+?\.html[^>]*?>\s*?v?(\d+(?:\.\d+)+)\s*?</i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "4d721df11b75db14323549c9d8e763d1d61b97fa62fe4a42756c703c89ccf9d8"
    sha256 cellar: :any,                 arm64_sonoma:   "f369912769ac4893907478f69cf2dfdf5176c1ed95ae962abbb85caf41d63e44"
    sha256 cellar: :any,                 arm64_ventura:  "a50051c9e268cf2b124cf639a57f8c04422ba31a132316d32476abc2db857309"
    sha256 cellar: :any,                 arm64_monterey: "cf88f8f0bc4aa0d89fec6d9506bc5500159344d19ee71deeef59ce00cc14cdbb"
    sha256 cellar: :any,                 sonoma:         "83f9e9762faf3019cade567db83df8589c85fc6ab63b5ac5ea197c6b1f02b733"
    sha256 cellar: :any,                 ventura:        "aa70ba4ab1cccf6b9626a9e292a04ad7ecd8d9b9ae153e203d2022a26e453c71"
    sha256 cellar: :any,                 monterey:       "4b0478f5f42f83f64b7dc8bae45481c60b8a008f6f9b64b496755ac595fab6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "751adff3a7106fe1bf6f272c863933d9372a2a4f11a8861af71194f9a0476435"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.12" => :build
  depends_on "sphinx-doc" => :build
  depends_on "xz" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  # Build uses sed -r option, which is not available in Catalina shipped sed.
  on_catalina :or_older do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "gmp" => :build
  end

  # A binary of ghc is needed to bootstrap ghc
  resource "binary" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-aarch64-apple-darwin.tar.xz"
        sha256 "67be089dedbe599d911efd8f82e4f9a19225761a3872be74dfd4b5a557fb8e1a"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-x86_64-apple-darwin.tar.xz"
        sha256 "64e8cca6310443cd6de8255edcf391d937829792e701167f7e5fb234f7150078"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-aarch64-deb10-linux.tar.xz"
        sha256 "9a3776fd8dc02f95b751f0e44823d6727dea2c212857e2c5c5f6a38a034d1575"
      end
      on_intel do
        url "https://downloads.haskell.org/~ghc/9.8.2/ghc-9.8.2-x86_64-ubuntu20_04-linux.tar.xz"
        sha256 "a65a4726203c606b58a7f6b714a576e7d81390158c8afa0dece3841a4c602de2"
      end
    end
  end

  resource "cabal-install" do
    on_macos do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-aarch64-darwin.tar.xz"
        sha256 "9c165ca9a2e593b12dbb0eca92c0b04f8d1c259871742d7e9afc352364fe7a3f"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-darwin.tar.xz"
        sha256 "e89392429f59bbcfaf07e1164e55bc63bba8e5c788afe43c94e00b515c1578af"
      end
    end
    on_linux do
      on_arm do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-aarch64-linux-deb10.tar.xz"
        sha256 "c01f2e0b3ba1fe4104cf2933ee18558a9b81d85831a145e8aba33fa172c7c618"
      end
      on_intel do
        url "https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-linux-ubuntu20_04.tar.xz"
        sha256 "3724f2aa22f330c5e6605978f3dd9adee4e052866321a8dd222944cd178c3c24"
      end
    end
  end

  def install
    # ENV.cc returns a specific version of gcc on Ubuntu, e.g. gcc-11
    # on Ubuntu 22.04. Using this value for ENV["CC"] effectively causes
    # the bottle (binary package) to only run on systems where a gcc-11 binary
    # is available. This breaks on many systems including Arch Linux, Fedora
    # and Ubuntu 24.04, as they provide gcc but not gcc-11 specifically.
    #
    # The workaround here is to hardcode the ENV["CC"] value to "cc".
    ENV["CC"] = ENV["ac_cv_path_CC"] = OS.linux? ? "cc" : ENV.cc
    ENV["LD"] = ENV["MergeObjsCmd"] = "ld"
    ENV["PYTHON"] = which("python3.12")

    binary = buildpath/"binary"
    resource("binary").stage do
      binary_args = []
      if OS.linux?
        binary_args << "--with-gmp-includes=#{Formula["gmp"].opt_include}"
        binary_args << "--with-gmp-libraries=#{Formula["gmp"].opt_lib}"
      end

      system "./configure", "--prefix=#{binary}", *binary_args
      ENV.deparallelize { system "make", "install" }
    end

    ENV.prepend_path "PATH", binary/"bin"
    # Build uses sed -r option, which is not available in Catalina shipped sed.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac? && MacOS.version <= :catalina

    resource("cabal-install").stage { (binary/"bin").install "cabal" }
    system "cabal", "v2-update"
    if build.head?
      cabal_args = std_cabal_v2_args.reject { |s| s["installdir"] }
      system "cabal", "v2-install", "alex", "happy", *cabal_args, "--installdir=#{binary}/bin"
      system "./boot"
    end

    args = []
    if OS.mac?
      # https://gitlab.haskell.org/ghc/ghc/-/issues/22595#note_468423
      args << "--with-ffi-libraries=#{MacOS.sdk_path_if_needed}/usr/lib"
      args << "--with-ffi-includes=#{MacOS.sdk_path_if_needed}/usr/include/ffi"
      args << "--with-system-libffi"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-numa", "--with-intree-gmp", *args
    hadrian_args = %W[
      -j#{ENV.make_jobs}
      --prefix=#{prefix}
      --flavour=release
      --docs=no-sphinx-pdfs
    ]
    # Let hadrian handle its own parallelization
    ENV.deparallelize { system "hadrian/build", "install", *hadrian_args }

    bash_completion.install "utils/completion/ghc.bash" => "ghc"
    ghc_libdir = build.head? ? lib.glob("ghc-*").first : lib/"ghc-#{version}"
    (ghc_libdir/"lib/package.conf.d/package.cache").unlink
    (ghc_libdir/"lib/package.conf.d/package.cache.lock").unlink
  end

  def post_install
    system bin/"ghc-pkg", "recache"
  end

  test do
    (testpath/"hello.hs").write('main = putStrLn "Hello Homebrew"')
    assert_match "Hello Homebrew", shell_output("#{bin}/runghc hello.hs")
  end
end
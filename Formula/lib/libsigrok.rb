class Libsigrok < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  # libserialport is LGPL3+
  # fw-fx2lafw is GPL-2.0-or-later and LGPL-2.1-or-later"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 5

  stable do
    url "https://sigrok.org/download/source/libsigrok/libsigrok-0.5.2.tar.gz"
    sha256 "4d341f90b6220d3e8cb251dacf726c41165285612248f2c52d15df4590a1ce3c"

    # build patch to replace `PyEval_CallObject` with `PyObject_CallObject`
    patch do
      url "https://github.com/sigrokproject/libsigrok/commit/5bc8174531df86991ba8aa6d12942923925d9e72.patch?full_index=1"
      sha256 "247bfee9777a39d5dc454a999ce425a061cdc48f4956fdb0cc31ec67a8086ce0"
    end

    resource "libserialport" do
      url "https://sigrok.org/download/source/libserialport/libserialport-0.1.1.tar.gz"
      sha256 "4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d"
    end

    resource "fw-fx2lafw" do
      url "https://sigrok.org/download/source/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-0.1.7.tar.gz"
      sha256 "a3f440d6a852a46e2c5d199fc1c8e4dacd006bc04e0d5576298ee55d056ace3b"

      # Backport fixes to build with sdcc>=4.2.3. Remove in the next release of fw-fx2lafw.
      patch do
        url "https://sigrok.org/gitweb/?p=sigrok-firmware-fx2lafw.git;a=commitdiff_plain;h=5aab87d358a4585a10ad89277bb88ad139077abd"
        sha256 "9615c2f25eb03faeca73c8233353698236dc9f16c38e250f3cec4a7bb5d9f15d"
      end
      patch do
        url "https://sigrok.org/gitweb/?p=sigrok-firmware-fx2lafw.git;a=commitdiff_plain;h=3e08500d22f87f69941b65cf8b8c1b85f9b41173"
        sha256 "f9c93c9ac88802173cb37528766d95c231288f343ee5842a1d8bc9f617794c33"
      end
      patch do
        url "https://sigrok.org/gitweb/?p=sigrok-firmware-fx2lafw.git;a=commitdiff_plain;h=96b0b476522c3f93a47ff8f479ec08105ba6a2a5"
        sha256 "1d5d9a7d2e8e7e1b99c57f15093bbffed87d5750caa13b797cd3199438d4c990"
      end
    end
  end

  # The upstream website has gone down due to a server failure and the previous
  # download page is not available, so this checks the directory listing page
  # where the `stable` archive is found until the download page returns.
  livecheck do
    url "https://sigrok.org/download/source/libsigrok/"
    regex(/href=.*?libsigrok[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "03697dd6796dbddcb4602fda39063dece9e3bf49f78b34ae7eafad696074434e"
    sha256                               arm64_sequoia: "f87ecb91e13c521fcdbb1a3fb7bcccdaf0e1756b08108181dc31bf41fc78c00c"
    sha256                               arm64_sonoma:  "9653da1e1ac058c2f4e2a4d0eaa2219aeab0518e517873a92a0bffb8ae7de274"
    sha256                               sonoma:        "55774dcb178d0e94dbc0724393dfcc32fd72fb18f4aa8716b1570becd3371287"
    sha256                               arm64_linux:   "2217949eee6fb0bbdb020a98b6df00bfdf6e9f486f738f62332a39f681be1d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3c6925a66722db026365cc0a8ee44e92f658384f12b3ec66bf4b4976eebacc"
  end

  head do
    url "git://sigrok.org/libsigrok", branch: "master"

    resource "libserialport" do
      url "git://sigrok.org/libserialport", branch: "master"
    end

    resource "fw-fx2lafw" do
      url "git://sigrok.org/sigrok-firmware-fx2lafw", branch: "master"
    end
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "sdcc" => :build
  depends_on "swig" => :build
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libzip"
  depends_on "nettle"
  depends_on "numpy"
  depends_on "pygobject3"
  depends_on "python@3.13"

  on_macos do
    depends_on "gettext"
    depends_on "libsigc++@2"
  end

  resource "fw-fx2lafw" do
    url "https://sigrok.org/download/binary/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-bin-0.1.7.tar.gz"
    sha256 "c876fd075549e7783a6d5bfc8d99a695cfc583ddbcea0217d8e3f9351d1723af"
  end

  def python3
    "python3.13"
  end

  def install
    resource("fw-fx2lafw").stage do
      if build.head?
        system "./autogen.sh"
      else
        system "autoreconf", "--force", "--install", "--verbose"
      end

      mkdir "build" do
        system "../configure", *std_configure_args
        system "make", "install"
      end
    end

    resource("libserialport").stage do
      if build.head?
        system "./autogen.sh"
      else
        system "autoreconf", "--force", "--install", "--verbose"
      end

      mkdir "build" do
        system "../configure", *std_configure_args
        system "make", "install"
      end
    end

    # We need to use the Makefile to generate all of the dependencies
    # for setup.py, so the easiest way to make the Python libraries
    # work is to adjust setup.py's arguments here.
    prefix_site_packages = prefix/Language::Python.site_packages(python3)
    inreplace "Makefile.am" do |s|
      s.gsub!(/^(setup_py =.*setup\.py .*)/, "\\1 --no-user-cfg")
      s.gsub!(
        /(\$\(setup_py\) install)/,
        "\\1 --single-version-externally-managed --record=installed.txt --install-lib=#{prefix_site_packages}",
      )
    end

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "--force", "--install", "--verbose"
    end

    mkdir "build" do
      ENV["PYTHON"] = python3
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      args = %w[
        --disable-java
        --disable-ruby
      ]
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libsigrok/libsigrok.h>

      int main() {
        struct sr_context *ctx;
        if (sr_init(&ctx) != SR_OK) {
           exit(EXIT_FAILURE);
        }
        if (sr_exit(ctx) != SR_OK) {
           exit(EXIT_FAILURE);
        }
        return 0;
      }
    C
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libsigrok").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    system python3, "-c", <<~PYTHON
      import sigrok.core as sr
      sr.Context.create()
    PYTHON
  end
end
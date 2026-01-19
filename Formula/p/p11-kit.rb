class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://ghfast.top/https://github.com/p11-glue/p11-kit/releases/download/0.26.0/p11-kit-0.26.0.tar.xz"
  sha256 "a30a8cdfd0b0e22a6effe70d77c3d9144b74b7e267f288a2e3adcd966ff091cc"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "79ba915797339366a677db0747cc892528b3129153620341c1d2c907d1b2f486"
    sha256 arm64_sequoia: "ad6bc0c8701943454b8d62d344a32c8175e26612c79acd2fc1d4b63dc0fe6bd1"
    sha256 arm64_sonoma:  "385e3155297fd7f8b82291ccbf9e2dd3e843d739b9bd91482e6e1bffa607a9ac"
    sha256 sonoma:        "4b8f3e668f32fb8acfce86e0b64542a9cda4e4cf15d6d282b9e41affe10ab145"
    sha256 arm64_linux:   "fb1ab4619bcc6a6161f35110fd500f9c1345b965e5ed1c48d82527afa0b8117a"
    sha256 x86_64_linux:  "132503f1cdace7020bc6dddd0b2307e66ba58973a4f95d5f56de5419c19ce63e"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    args = %W[
      -Dsystem_config=#{etc}
      -Dmodule_config=#{etc}/pkcs11/modules
      -Dtrust_paths=#{etc}/ca-certificates/cert.pem
      -Dsystemd=disabled
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "meson", "test", "-C", "_build", "--timeout-multiplier=2"
    system "meson", "install", "-C", "_build"

    # HACK: Work around p11-kit: couldn't load module: .../lib/pkcs11/p11-kit-trust.so
    # Issue ref: https://github.com/p11-glue/p11-kit/issues/612
    (lib/"pkcs11").install_symlink "p11-kit-trust.dylib" => "p11-kit-trust.so" if OS.mac?
  end

  test do
    assert_match "library-manufacturer: PKCS#11 Kit", shell_output("#{bin}/p11-kit list-modules --verbose")
  end
end
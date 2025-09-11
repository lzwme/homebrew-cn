class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://ghfast.top/https://github.com/p11-glue/p11-kit/releases/download/0.25.7/p11-kit-0.25.7.tar.xz"
  sha256 "6b31a9defa34802d6d88df5010b8b14e24051bf4d15070e8c920d5e8717555a0"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "e0e8c2104e2dcd949f3b97366279c901522053f57c2189d0314b4744ac5093d0"
    sha256 arm64_sequoia: "60dcadb4ab610a38b5d8e83ab4d3d5bf66ef39b490fcd99773b6eaa900fd523b"
    sha256 arm64_sonoma:  "e39a2ccbf0f1401c60557725332f5171db750ffc148ce9d03fe433f19a66d963"
    sha256 arm64_ventura: "bca93592779f526e7a4e540f56f1da510f17fedfc60287940249b2bbce9b3330"
    sha256 sonoma:        "3c5d0372bd184a7335e4dabb9775fda7a10ac2114dbad86cd007133609cbfbef"
    sha256 ventura:       "5b1cd7f5b4aea69f8048ec7d7aa6d1752f49231e62b1a74b1d1f79c5a22a4593"
    sha256 arm64_linux:   "2b0f2dee536d9c8209e9c1f2e1e55d945585fa1b0cf3607ef4918982d539f414"
    sha256 x86_64_linux:  "6c6c94ccc3eefd0c075d53255825fd0c26beb718fff20d79ebd211e4d10ff6b0"
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

  uses_from_macos "libffi", since: :catalina

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
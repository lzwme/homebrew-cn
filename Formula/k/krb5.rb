class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.tar.gz"
  sha256 "652be617b4647f3c5dcac21547d47c7097101aad4e306f1778fb48e17b220ba3"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_sequoia: "aea4f804ea4778c69376daab5d35b931a2e2ed7059f824882c003ff6c9995214"
    sha256 arm64_sonoma:  "1a588cbda0b4519817d295ac3c2cd1b730a77f62c4a3f349cc9adfb7163b0aee"
    sha256 arm64_ventura: "5f75201970b8c8885970238475a68265721e86d4e23f08fd9db7825e9ff0173a"
    sha256 sonoma:        "2ea0c30ca5125e0cba9661a90e3c0f165a371a63c6b66cd0feeea1fa310bcd29"
    sha256 ventura:       "bccc282e81a74e093965f2ba6b522d37a82bf245d9c457b3bf12fcaddc61c8f4"
    sha256 arm64_linux:   "59c162205019ccaf9dede4cf7fc118f49e4e525bb7972b7e9d7738cafdcb8211"
    sha256 x86_64_linux:  "eb0848f3081717452b543b304515d1b9a6a0023618dfe7af1f9db9635041df10"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    cd "src" do
      system "./configure", *std_configure_args,
                            "--disable-nls",
                            "--disable-silent-rules",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20250603.tar.gz"
  sha256 "f9062166bfb99275a1abb77efeba819819e9c57fb8acdee39f04163f7476a34c"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cf14e9de8f204a6b2956eb7882f24a02f4b31bf89ded87bac3532ed8ed3b3aa"
    sha256 cellar: :any,                 arm64_sonoma:  "478376ee553099d714b13f31ac5d761bee908061757547441fdf9c56a308a599"
    sha256 cellar: :any,                 arm64_ventura: "6d1c12463c8cca7e2529fdd221ff241e88bab34d447bf2f5f77083c160357c95"
    sha256 cellar: :any,                 sonoma:        "e419bf87db091ed1ad8979831bdde86d287123bd9ee003c9b774090df1c401bb"
    sha256 cellar: :any,                 ventura:       "0d65830e6e280fc70cf8cca2c71f016909e179316f84964dc6c52f23bd9136a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f974828d6e32a709531eaf9f986a45aef745e31e30e5394c8c4be8e1deb14618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c161ec3e960d38ce717a8b4121f38d9b781630a32c8c98a0e95c874d224efcad"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end
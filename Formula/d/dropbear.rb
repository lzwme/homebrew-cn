class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2026.93.tar.bz2"
  sha256 "310a6087952897c182efbe16088fa0c4d07c467e850a22699472137278fabf09"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?dropbear[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b498ced8c41779dc2223bf2073b2a59521d13e9810eb8a9f722dcde1460ec8e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de46897521cf46f9c0e253856bfb14773715dcb937a13621a1baaae8c3d573b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58d5b67dc05ca8990def13c1156b0529435223eaad916f701ae766c51de126b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ec78a0cb39cfb389e93df1aa78e1ad59f5aac41d9b7953bb74def70b0b0b2e2"
    sha256 cellar: :any,                 arm64_linux:   "9fd1461e0843e69b2e1de26d4831152252d81395eae2b649d53e38252ce53278"
    sha256 cellar: :any,                 x86_64_linux:  "028ce8bdc2ed5a8ae0a44a9089773365c4e70a7a7d8f414015d6ec6c616fe2a0"
  end

  head do
    url "https://github.com/mkj/dropbear.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize

    # It doesn't compile on macOS with these macros because of the missing `setresgid()` function
    # There's no option to disable it via `./configure` flags and upstream suggests to fix it
    # by changing `src/default_options.h` manually (see `CHANGES`)
    if OS.mac?
      inreplace "src/default_options.h" do |s|
        s.gsub! "#define DROPBEAR_SVR_DROP_PRIVS DROPBEAR_SVR_MULTIUSER",
                "#define DROPBEAR_SVR_DROP_PRIVS 0"
        s.gsub! "#define DROPBEAR_SVR_LOCALSTREAMFWD 1",
                "#define DROPBEAR_SVR_LOCALSTREAMFWD 0"
      end
    end

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system bin/"dbclient", "-h"
    system bin/"dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_path_exists testfile
  end
end
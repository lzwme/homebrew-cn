class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://ghproxy.com/https://github.com/rfc1036/whois/archive/refs/tags/v5.5.19.tar.gz"
  sha256 "58602ce405a0d1f62fc99cd9e9e8cb3fb1ce05451a45a8d5b532bab5120d070e"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41c53e85335f31e6fd1861077c29a0a0551e2ca75d44cc60a5f996b25d5646b7"
    sha256 cellar: :any,                 arm64_ventura:  "6dc6fdb9256c56d861259e88bbeac71621ade94763861b55399ca27fd70470a8"
    sha256 cellar: :any,                 arm64_monterey: "451e37b49d6538a39c8a9c6b6a09bf889d37fa4583397330a72b4aee50d61093"
    sha256 cellar: :any,                 sonoma:         "76c0f9dc1d9606038db51379885bd08b75f0b448fc3ffd835db00330697d7a41"
    sha256 cellar: :any,                 ventura:        "ade62ab5b4f4fd14cb4cb7748204f1fd88af48a40e17e725b67eee3e0c05c48f"
    sha256 cellar: :any,                 monterey:       "42964980f806002fbb7124737486a944739328a184a760f5682564ea1babb76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65016ba396f128386b057dec572abe7a1f17de0a713fd40c5d954ca01dd51bf6"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  # fix build failure with clang
  # upstream patch, https://github.com/rfc1036/whois/pull/156
  patch do
    url "https://github.com/rfc1036/whois/commit/2fdc7a921dc5fd9ccd156627b96eaeb25d710302.patch?full_index=1"
    sha256 "38d1f108cb10db3c4ccf451fd3f5497ecd0b3f8421df84a64f4fa617085b0c23"
  end

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
    end

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.10.tar.xz"
  sha256 "55258f9955912fde0702a77db4d924ac0bce30548950320c9fef2bec520edc2a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5705a8cba781c0b314e21d8f73ba5c809bb612eda070863a57d4aea7e8fc33d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "638c5c681db6765871414762476afa643488cde17f864ac09db6583dcc727f2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0da85271df3d8ff92ee4499e8285c40853d173a4e8fffee042b4d075f4d45b0"
    sha256 cellar: :any_skip_relocation, ventura:        "490203f78c4009bedf54432f78261adbd9b5bdabf441dc5905cab596c0c5a40a"
    sha256 cellar: :any_skip_relocation, monterey:       "89b887f12fd2130078bfdf41790c65b2ac5425bf094a03281fdca7294a5981f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c35386ea9a33a74d6c477b6a74520d20a04e73ffac91f069bda6ff56b8dc9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00af0f3d23a37e84c071eb6213d2e84a844e3349557220f9c19f1bdd6c6ddc6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build # for libintl
  depends_on "libtool" => :build
  depends_on "po4a" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
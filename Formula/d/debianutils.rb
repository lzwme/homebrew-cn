class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.12.tar.xz"
  sha256 "d386dad5e5b957d35f75a23a7543d45459718e06ab185896dc0eb5054e6e2e3b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de78764f156cf682cf10a77cfeba54a010cb82c4bc765a9c944315234fb1b1f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a595b3401e3746f348e2e6c1400ddd59a96cc9a0a43c2e5bfe8dea738418460a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f5f857a75516c6dbfc0cf47a001b5ca3a8855ea9bf22dc9425265ff7f7951c"
    sha256 cellar: :any_skip_relocation, ventura:        "ad907e4dba6762f4d31b20e179f71ab6da02addfa3d1190f396ac9c626ce2c36"
    sha256 cellar: :any_skip_relocation, monterey:       "c0aa2b51ce133129ea784a6780901069b232c9c491273585eda03e08b39da7fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "70365e73f53ed17b11eae9d314ab6b634d464d4c4d49427870a79e39ab33d640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57a7cd184f6cc892d91aefeefc1c1fe956ff815be84cf3d4f9b26f602178be1"
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
class Patchutils < Formula
  desc "Small collection of programs that operate on patch files"
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.4.2.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/p/patchutils/patchutils_0.4.2.orig.tar.xz"
  sha256 "8875b0965fe33de62b890f6cd793be7fafe41a4e552edbf641f1fed5ebbf45ed"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "http://cyberelk.net/tim/data/patchutils/stable/"
    regex(/href=.*?patchutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ebaaeda4882f4e6dd9d0846db19d4def5d2d3a975996c7c41ab3d38dfaaa19d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3008f1cd6e1e6907825d99562cba86f85284013eaa46202236a11e043558d3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e49dcfa14b90a261ebaa265f80d2eb895c419457ca4fa26ff0fb4cb11b921e9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1198ecdb82f8fdb68b989ad39a3afdce9caeb9553b462f2fb337c6671b7767b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5cba6808061043a4275dfff1ffbc9dfc623b604bd80df87731302d24d9e8a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3cb01b0c0f9df8fbb423782b2c80ce73e1f6e108200185c4a548fc817adb2f7"
    sha256 cellar: :any_skip_relocation, ventura:        "3809ec36a492f423a2e1d1eb2eb046bd2d4f0c780c79ebf98e0827e387b5adf2"
    sha256 cellar: :any_skip_relocation, monterey:       "827a4a8a0b1532b302f0b19db90f4f7fbc561057d1c7b95677f89ba955bc21da"
    sha256 cellar: :any_skip_relocation, big_sur:        "2305540f050f688ecb19afbd61daaee0dc51cf27d43cd2baff3e8542ea631680"
    sha256 cellar: :any_skip_relocation, catalina:       "3ee4d0c62b3f2b26e28fbf476c37eaeb8ccca9000c4f8f2766cd2c662de855bc"
    sha256 cellar: :any_skip_relocation, mojave:         "12cd388801c5c628db409cb043d6a2fc436f44ae8f01a754f430763380043af4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "84b5013e7c6647e1cda9faa1ab9b31834ed6e2ef6c1a48d21ab7c459dc4462b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b3d285fd561ed5b073a80c22f965792d0fd9f5c18e3b8cd91fd9b441cada08c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3195e7dccef8379cfd2976c51bb7675cd170783f0017232749cd0a18487345ae"
  end

  head do
    url "https://github.com/twaugh/patchutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook" => :build
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog" if build.head?
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match %r{a/libexec/NOOP}, shell_output("#{bin}/lsdiff #{test_fixtures("test.diff")}")
  end
end
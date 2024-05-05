class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https:aide.github.io"
  url "https:github.comaideaidereleasesdownloadv0.18.7aide-0.18.7.tar.gz"
  sha256 "85251284ed91d0cc1131a08e97751823895a263e75de5c04c615326099500cc9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "907c69bf8334c7f9c281f4600deb09e1c582b63e7722e9716e337a64b19e3380"
    sha256 cellar: :any,                 arm64_ventura:  "f496efdcb512d0d93f00991bcef663e20b7b23696c1a7acd55ba907b5a9b3052"
    sha256 cellar: :any,                 arm64_monterey: "df005fe9daf03375e5917de2348f83d5922dac145f76ef408ae4a2f1f1e532b7"
    sha256 cellar: :any,                 sonoma:         "f0530bb06e643ae6becca899bf1641838a5fc81d1e8ddeb4aadfa874f8d82b3a"
    sha256 cellar: :any,                 ventura:        "13bd65edb74808d770a1dc85deed1e6dd32fb77821558733c057bba304f0b49a"
    sha256 cellar: :any,                 monterey:       "0cd61ba45c5e69bd40e0cf192465cfc665b58dd693a5da5cd1621a11fa42fb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefb4652b3f42e6462c30bf49732bb3bcd4b36f1f36fafdec506c5fcc5139cca"
  end

  head do
    url "https:github.comaideaide.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", ".autogen.sh" if build.head?

    args = %W[
      --disable-lfs
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
      --prefix=#{prefix}
    ]

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
    end

    system ".configure", *args

    system "make", "install"
  end

  test do
    (testpath"aide.conf").write <<~EOS
      database_in = file:varlibaideaide.db
      database_out = file:varlibaideaide.db.new
      database_new = file:varlibaideaide.db.new
      gzip_dbout = yes
      report_summarize_changes = yes
      report_grouped = yes
      log_level = info
      database_attrs = sha256
      etc p+i+u+g+sha256
    EOS
    system "#{bin}aide", "--config-check", "-c", "aide.conf"
  end
end
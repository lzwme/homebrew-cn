class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://ghproxy.com/https://github.com/aide/aide/releases/download/v0.18.5/aide-0.18.5.tar.gz"
  sha256 "58d63e6d16f5af296da427313861222426aec7610f4dbc76a1bc76310e1f1db5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fb49ae529262a738eefdc9d67ae93224ae5093680e4fb3dbc5418d64aae8785"
    sha256 cellar: :any,                 arm64_monterey: "3792cb0302d002a7fab266f4e2e22d4f4607e849bd5e1e28deccc771de97d6bf"
    sha256 cellar: :any,                 arm64_big_sur:  "f4eda2614d304b586b9ae869b2ca5d2c19ea7e7cca8467c7c5a9075d75545567"
    sha256 cellar: :any,                 ventura:        "bdaaf12b2b0fb466f1c5f7ba0a57e2e374f5579062bfed8c5c24f3d24f035ffb"
    sha256 cellar: :any,                 monterey:       "4b0b8cecde36adec529977abbc20bedd1606d2df204af141cf667be8a5b59740"
    sha256 cellar: :any,                 big_sur:        "8ff30ceb47ece427794d1005da9e751845596dc917062a6f6a2a9697ea39c30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71083559a943c8a37a0c4ae63c22f88625ff45490b7453ed307e9af98aa59ef"
  end

  head do
    url "https://github.com/aide/aide.git", branch: "master"
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

    system "sh", "./autogen.sh" if build.head?

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

    system "./configure", *args

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<~EOS
      database_in = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      report_summarize_changes = yes
      report_grouped = yes
      log_level = info
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://ghfast.top/https://github.com/aide/aide/releases/download/v0.19.3/aide-0.19.3.tar.gz"
  sha256 "6513170bb5b8c22802dd1b72f02d8aa9f432aef2b4470522db03e755212a3f47"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b824511e574b671dda7775cbdad34a85c266b5a0ace089f4f89dff39d2de0f3"
    sha256 cellar: :any,                 arm64_sequoia: "c67d531ee376c102f48595f783ef7d3cad7a2eae40e0e61f8560a9f8c8ea9c0f"
    sha256 cellar: :any,                 arm64_sonoma:  "db187e522297a83172d1be7002d7883d6789033fb0cace18819f4c84cfbecdc4"
    sha256 cellar: :any,                 sonoma:        "c822520dc070ec4bf8d031f5e70b6a40cc0878be9aa0c332bfa4fa9c9813805f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b37079e50567281c1c16aec7437e4030b721957e99fde442d969cd401c5c64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55e9f7050b86e90ce4e45358f9c5aadbee151bc541d934342b9c885be6ec227"
  end

  head do
    url "https://github.com/aide/aide.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with cask: "aide-app"

  def install
    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
    ]

    args << if OS.mac?
      "--with-curl"
    else
      "--with-curl=#{Formula["curl"].prefix}"
    end

    system "./configure", *args, *std_configure_args
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
    system bin/"aide", "--config-check", "-c", "aide.conf"
  end
end
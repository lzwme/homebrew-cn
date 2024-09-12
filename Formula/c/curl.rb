class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https:curl.se"
  # Don't forget to update both instances of the version in the GitHub mirror URL.
  url "https:curl.sedownloadcurl-8.10.0.tar.bz2"
  mirror "https:github.comcurlcurlreleasesdownloadcurl-8_10_0curl-8.10.0.tar.bz2"
  mirror "http:fresh-center.netlinuxwwwcurl-8.10.0.tar.bz2"
  mirror "http:fresh-center.netlinuxwwwlegacycurl-8.10.0.tar.bz2"
  sha256 "be30a51f7bbe8819adf5a8e8cc6991393ede31f782b8de7b46235cc1eb7beb9f"
  license "curl"

  livecheck do
    url "https:curl.sedownload"
    regex(href=.*?curl[._-]v?(.*?)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9564f720c852a406753153172001c65bb7d5923eea4cbabaad782d2c8b21b5c1"
    sha256 cellar: :any,                 arm64_sonoma:   "70394bb680b22b283dc6ac7f77ea27875cd119a8b42a1c71e4f4fb38be353c41"
    sha256 cellar: :any,                 arm64_ventura:  "fd34131aa476d59215a8649ffc6a4cc284330e1d8bbdd0832cbd28ef6fb57226"
    sha256 cellar: :any,                 arm64_monterey: "43ef3f8a1f65df2d33e9c6cc0f521d0b4a199e4bc6b63f4df1d6501b51111930"
    sha256 cellar: :any,                 sonoma:         "7a4c75046f28019959227300f2a373f9cf708d8fd7df01d71b11fae5ad75f4a5"
    sha256 cellar: :any,                 ventura:        "1c482349786fde529e4eb5f8de85c6c82423d8c1d7c258c0634fc6abf5f3e2ba"
    sha256 cellar: :any,                 monterey:       "ed2b335d562d7789463d57d0d72ff0bf8054c1e228c01ad33d3d8de43099e29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "080b25174c4b18328c5ee27d0270afda9c844f8a54949d97ca64ed5fe09bbad9"
  end

  head do
    url "https:github.comcurlcurl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libssh2"
  depends_on "openssl@3"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "krb5"
  uses_from_macos "openldap"
  uses_from_macos "zlib"

  # Prevents segfault in julia test - https:github.comcurlcurlpull14862
  patch do
    url "https:github.comcurlcurlcommit60ac76d67bf32dfb020cd155fc27fe1f03ac404f.patch?full_index=1"
    sha256 "c9330acd41390cada341322c81affba24fb422b1123ee4360c2a617a42d6f517"
  end

  def install
    tag_name = "curl-#{version.to_s.tr(".", "_")}"
    if build.stable? && stable.mirrors.grep(github\.com).first.exclude?(tag_name)
      odie "Tag name #{tag_name} is not found in the GitHub mirror URL! " \
           "Please make sure the URL is correct."
    end

    system ".buildconf" if build.head?

    args = %W[
      --disable-silent-rules
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-ca-bundle
      --without-ca-path
      --with-ca-fallback
      --with-secure-transport
      --with-default-ssl-backend=openssl
      --with-libidn2
      --with-librtmp
      --with-libssh2
      --without-libpsl
      --with-zsh-functions-dir=#{zsh_completion}
      --with-fish-functions-dir=#{fish_completion}
    ]

    args << if OS.mac?
      "--with-gssapi"
    else
      "--with-gssapi=#{Formula["krb5"].opt_prefix}"
    end

    system ".configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "scriptsmk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath"test.tar.gz")
    system bin"curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath"test.pem", :exist?
    assert_predicate testpath"certdata.txt", :exist?
  end
end
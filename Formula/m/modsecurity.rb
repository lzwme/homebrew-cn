class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https:github.comSpiderLabsModSecurity"
  url "https:github.comSpiderLabsModSecurityreleasesdownloadv3.0.10modsecurity-v3.0.10.tar.gz"
  sha256 "d5d459f7c2e57a69a405f3222d8e285de419a594b0ea8829058709962227ead0"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "71154816630314ecc628277efa6ca6610a56350090de4234afc77cec5640b86f"
    sha256 cellar: :any,                 arm64_ventura:  "dbf704acb2a892b25d57b1c135b98d5a3197af17c423b483f32176ef1df835c7"
    sha256 cellar: :any,                 arm64_monterey: "4b84d1cd638486de1ed6337f5256f08a256bb186630265c893e2caa2aa7f693e"
    sha256 cellar: :any,                 sonoma:         "95cc99b3cdda19c76142da1cb782880ff586afb5b29694a782a0c2f17684b414"
    sha256 cellar: :any,                 ventura:        "1e8f0dc7db3d1692ad6df0bb8d429da7be0a2d2825b30370cd73f40369bbe309"
    sha256 cellar: :any,                 monterey:       "0b99dec932e2fe5d3531e65b8c935888ab2d5487f2f6bf8535b7c5127d710a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4389a2c8634f393b9a02a2948dd14811ee26f83215f6afed6858fe5e6683de9c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "pcre2"
  depends_on "yajl"

  uses_from_macos "curl", since: :monterey
  uses_from_macos "libxml2"

  # Use ArchLinux patch to fix build with libxml2 2.12.
  # TODO: Check if fixed in future libxml2 release.
  # Issue ref: https:github.comSpiderLabsModSecurityissues3023
  patch do
    url "https:gitlab.archlinux.orgarchlinuxpackagingpackageslibmodsecurity-raw5c78cfaaeb00c842731c52851341884c74bdc9b2libxml-includes.patch"
    sha256 "7ee0adbe5b164ca512c49e51e30ffd41e29244156a695e619dcf1d0387e69aef"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    libxml2 = OS.mac? ? "#{MacOS.sdk_path_if_needed}usr" : Formula["libxml2"].opt_prefix

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua"].opt_prefix}",
      "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
      "--with-yajl=#{Formula["yajl"].opt_prefix}",
      "--without-geoip",
    ]

    system ".configure", *args, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}modsec-rules-check \"SecAuditEngine RelevantOnly\"")
    assert_match("Test ok", output)
  end
end
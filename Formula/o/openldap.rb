class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https:www.openldap.orgsoftware"
  url "https:www.openldap.orgsoftwaredownloadOpenLDAPopenldap-releaseopenldap-2.6.10.tgz"
  mirror "http:fresh-center.netlinuxmiscopenldap-2.6.10.tgz"
  mirror "http:fresh-center.netlinuxmisclegacyopenldap-2.6.10.tgz"
  sha256 "c065f04aad42737aebd60b2fe4939704ac844266bc0aeaa1609f0cad987be516"
  license "OLDAP-2.8"

  livecheck do
    url "https:www.openldap.orgsoftwaredownloadOpenLDAPopenldap-release"
    regex(href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "fe7932d74b679ab0594c4013723eb14082a8a3ce7b988c6bdf864998e090d24e"
    sha256 arm64_sonoma:  "0ed851b33742a97a7f21b160d1e541123ef661e13f4aa2ccf1d30dd7079f2696"
    sha256 arm64_ventura: "73f5a30f37afaf85bc703f074556e4815f34d9781c7703e63610cf1cd10fffcd"
    sha256 sonoma:        "e69ae26f59606cd5578f0b03607da382a5625fe1364d628fdc93554f7bb2be4e"
    sha256 ventura:       "453c106685ec1346eebc7166f2b8df5dc36cc921a3150b9aeae8ef4edbd99dde"
    sha256 arm64_linux:   "183d21349be5f2256afc86ef4439f2563e6335d93ac060a15c52de91809b9c90"
    sha256 x86_64_linux:  "a352d40a8e1cd57f64d535055a0b4131b44a27cc6ec8443bf1fc6db43e572ded"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build

  on_linux do
    depends_on "util-linux"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
      --without-systemd
    ]

    soelim = if OS.mac?
      if MacOS.version >= :ventura
        "mandoc_soelim"
      else
        "soelim"
      end
    else
      "bsdsoelim"
    end

    system ".configure", *args
    system "make", "install", "SOELIM=#{soelim}"
    (var"run").mkpath

    # https:github.comHomebrewhomebrew-dupespull452
    chmod 0755, etc.glob("openldap*")
    chmod 0755, etc.glob("openldapschema*")

    # Don't embed Cellar references in files installed in `etc`.
    # Passing `build.bottle?` ensures that inreplace failures result in build failures
    # only when building a bottle. This helps avoid problems for users who build from source
    # and may have an old version of these files in `etc`.
    inreplace etc.glob("openldapslapd.{conf,ldif}"), prefix, opt_prefix, audit_result: build.bottle?
  end

  test do
    system sbin"slappasswd", "-s", "test"
  end
end